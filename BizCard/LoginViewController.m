//
//  ViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "LoginViewController.h"

#import "PlistClass.h"
#import "EvernoteSDK.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //---------------------------------------------------------------------
    //   처음 시작하면 로그인 정보가 있는지 확인해서 
    //           
    //   있으면 - 바로 앱으로 들어가고
    //   없으면 - 로그인 화면을 보여준다
    //---------------------------------------------------------------------
    [PlistClass DocumentFileCopy];
    [self check_login];

}


//----------------------------------------------------------------------------------------
// Evernote 로그인 되어 있는지 확인
//----------------------------------------------------------------------------------------
-(void)check_login{
    
    SJ_DEBUG_LOG(@"Checking Login");
    
    EvernoteUserStore *userStore = [EvernoteUserStore userStore];
    
    // Login이 이미 되어 있으면 (authenticated User 이면) 앱을 들어간다
    [userStore getUserWithSuccess:^(EDAMUser *user) {
        
        SJ_DEBUG_LOG(@"Login이 이미 되어 있습니다");
        [self check_notebook];
        
    } 
     // Login이 안 되있으면 로그인 화면을 간다 (로그인 버튼을 보여준다)
    failure:^(NSError *error) {
        SJ_DEBUG_LOG(@"로그인 정보가 없습니다.");
        loginBtn.hidden=NO;
    }];
}

//----------------------------------------------------------------------------------------
// 이 어플을 위한 notebook이 있는지 확인
//----------------------------------------------------------------------------------------
-(void)check_notebook{
    
    
    SJ_DEBUG_LOG(@"Notebook이 있는지 확인");
    
    NSString *notebook_Guid = [PlistClass read_notebook_guid];

    // 새 사용자이면 이 앱을 위한 notebook을 생성한다
    if([notebook_Guid isEqualToString:@"0"]){
        
        SJ_DEBUG_LOG(@"Notebook이 없음");
        [self createNotebook:@"BizCard"];
    }
    // 기존 사용자면 해당 guid
    else{
        SJ_DEBUG_LOG(@"Notebook이 있음");
       
        SJ_DEBUG_LOG(@"해당 Notebook이 유효한지 체크");
        EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
        [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {
            
            BOOL isAvaible = NO;
            
            for(int i=0; i < [notebooks count]; i++){
               
                // 해당 노트북이 유효하면
                if([[[notebooks objectAtIndex:i]guid] isEqualToString:notebook_Guid]){
                    SJ_DEBUG_LOG(@"Notebook이 유효");
                    isAvaible = YES;
                    
                // 해당 노프북이 유효하지 않으면 새로 노트북을 만든다
                }else{
                    SJ_DEBUG_LOG(@"Notebook이 유효하지 않음");
                }
            }
            
            if(isAvaible){
                [self gotoTabbarControllerView];
            }else{
                [self createNotebook:@"BizCard"];
            }
            
        } failure:^(NSError *error) {
            [self loginFailAlert];
        }];
        
    }
}


//----------------------------------------------------------------------------------------
// Notebook 만들기
//----------------------------------------------------------------------------------------
-(void)createNotebook:(NSString *)notebookName{
    
    SJ_DEBUG_LOG(@"Notebook 만들겠음");
    
    // Create Notebook
    EDAMNotebook* notebook = [[EDAMNotebook alloc] init];
    notebook.name = notebookName;    
    
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [noteStore createNotebook:notebook success:^(EDAMNotebook *notebook) {
        
        SJ_DEBUG_LOG(@"Notebook 생성 성공");
        SJ_DEBUG_LOG(@"GUID = %@", notebook.guid);
        
        [PlistClass write_notebook_guid:notebook.guid];            
        [self gotoTabbarControllerView];
        
    } failure:^(NSError *error) {
        
        SJ_DEBUG_LOG(@"Notebook 생성 실패");
        SJ_DEBUG_LOG(@"기본 노트북으로 설정하겠음");

        // Notebook 생성에 실패하면 기본 Notebook에 추가한다.
        [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {

            [PlistClass write_notebook_guid:[[notebooks objectAtIndex:0]guid]];
            [self gotoTabbarControllerView];

        } failure:^(NSError *error) {
            SJ_DEBUG_LOG(@"Notebook 설정 실패 로그인부터 재시도");
            loginBtn.hidden=NO;
        }];
    }];
    
}


//----------------------------------------------------------------------------------------
// 명함 화면으로 이동
//----------------------------------------------------------------------------------------
-(void)gotoTabbarControllerView{
    tabbarController = [[TabbarViewController alloc]init];
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:tabbarController animated:YES];
    
    
}




//----------------------------------------------------------------------------------------
// 로그인 버튼 눌렀을때
//----------------------------------------------------------------------------------------
- (IBAction)loginBtn:(id)sender {
    
    SJ_DEBUG_LOG(@"로그인을 하겠습니다");
    [self login];
}

//----------------------------------------------------------------------------------------
// Evernote 로그인하기 (성공하면 앱을 들어간다)
//----------------------------------------------------------------------------------------
-(void)login{
    
    EvernoteSession *session = [EvernoteSession sharedSession];
    
    [session authenticateWithViewController:self completionHandler:^(NSError *error) {
        
        
        // 로그인을 실패하면
        if (error || !session.isAuthenticated) {
            
            // Either we couldn't authenticate or something else went wrong - inform the user
            if (error) {
                SJ_DEBUG_LOG(@"Error authenticating with Evernote service: %@", error);
            }
            if (!session.isAuthenticated) {
                SJ_DEBUG_LOG(@"User could not be authenticated.");
            }
            
            [self loginFailAlert];
        } 
        
        // 로그인 성공하면 앱을 들어간다
        else {
            
            SJ_DEBUG_LOG(@"로그인 성공");
            [self check_notebook];
            
        } 
    }];
}




-(void)loginFailAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"로그인 실패. 다시 시도해주세요"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidUnload
{
    [self setLoginBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
