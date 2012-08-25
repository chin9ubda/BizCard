//
//  Add_MsgViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 22..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "Add_MsgViewController.h"

@interface Add_MsgViewController ()

@end

@implementation Add_MsgViewController
@synthesize delBtn, msg_TextView, msgScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [DataBase getInstance];
        nowId = 0;
    }
    return self;
}



/* ----------------------------------------
   Tabbar Hide, TextView Size Set
   ---------------------------------------- */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTextViewSize:) name:UIKeyboardWillShowNotification object:nil];
    msg_TextView.text = setText;
    [msg_TextView becomeFirstResponder];
    
    if (nowId == 0) {
        delBtn.hidden = YES;
        
    }
    
}

- (void)viewDidUnload
{
    [self setMsg_TextView:nil];
    [self setDelBtn:nil];
    [self setMsgScrollView:nil];
    [super viewDidUnload];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



// -------- TextView Size Setting -------- //

/* ----------------------------------------
   Keyboard 높이만큼 TextView 의 사이즈 변경
   ---------------------------------------- */
-(void)setTextViewSize:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [msg_TextView setFrame:CGRectMake(0, 0, msg_TextView.frame.size.width, msg_TextView.frame.size.height - kbSize.width)];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


// ------------ Set Msg ------------ //

/* ---------------------------------
   msg를 받아서 setText 변수에 저장
   내용이 있는 메시지를 클릭하였을 경우,
   해당 함수를 실행하여 메시지 전달
   --------------------------------- */

-(void)setTextView:(NSString *)msg{
    setText = msg;
}


// ------------ Set _id ------------ //

/* ---------------------------------
   _id를 받아서 setText 변수에 저장
   내용이 있는 메시지를 클릭하였을 경우,
   해당 함수를 실행하여 메시지 전달
  --------------------------------- */

-(void)setId:(int)_id{
    nowId = _id;
}




// ----- Delete Button Event ----- //

/* -------------------------------
          삭제 확인 Alert 노출
   ------------------------------- */

- (IBAction)delMsg:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"확  인" message:@"정말 삭제하시겠습니까?" delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
}



// ---------- Back Button Event ---------- //

/* ---------------------------------------
   Tabbar Open, View Remove, 
   Controller Remove, Notification Remove
   --------------------------------------- */

- (IBAction)backBtn:(id)sender {
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    [self removeFromParentViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



// ---------- Complate Button Event ---------- //

/* ---------------------------------------
   TextView 에 메시지가 있을 경우
   Id값을 사용하여 값을 Insert or Update
   Tabbar Open, View Remove,
   Controller Remove, Notification Remove
  --------------------------------------- */

- (IBAction)okBtn:(id)sender {
    if ([msg_TextView.text isEqualToString:@""]) {
        NSLog(@"Not Msg");
    }else{
        if (nowId == 0)
            [db insertMsg:msg_TextView.text];
        else
            [db updateMsg:nowId :msg_TextView.text];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"msgTableReload" object:nil];
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}


// ---------- alertView Setting ---------- //

/* ---------------------------------------
   삭제 확인 AlertView 가 나왔을 경우
   ok 버튼을 클리하면 저장된 id 값으로 Delete
   Tabbar Open, View Remove,
   Controller Remove, Notification Remove
   --------------------------------------- */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        NSLog(@"OK");
        [db deleteMsg:nowId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"msgTableReload" object:nil];
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

@end
