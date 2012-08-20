//
//  FirstTabViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "FirstTabViewController.h"
#import "BcTableCell.h"
#import "SelectViewController.h"

#define CardEdit 1
#define MemberEdit 2

#define GroupAddTag 11
#define GroupEditTag 12
#define GroupDelTag 13
#define GroupSms 14
#define GroupEmail 15

#define CardAddTag 21
#define CardDelTag 23
#define CardSms 24
#define CardEmail 25

@interface FirstTabViewController ()

@end

@implementation FirstTabViewController
@synthesize allGroupBtn;
@synthesize addGroupBtn;
@synthesize groupScrollView;
@synthesize businessCardTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [DataBase getInstance];
        dStruct = [DataStruct getInstance];
        [self reloadTableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setGroup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"reloadTableView" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setGroupScrollView:nil];
    [self setAllGroupBtn:nil];
    [self setAddGroupBtn:nil];
    [self setBusinessCardTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// ---------------- bcAddBtn Event ---------------- //
// --------------- show ActionSheet --------------- //
- (IBAction)bcAddBtn:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"취소"
                                  destructiveButtonTitle:@"사진 촬영"
                                  otherButtonTitles:@"앨범에서 가져오기", @"주소록에서 가져오기", @"직접 입력하기", nil];
    actionsheet.tag = CardAddTag;
    [actionsheet showInView:self.view];

}


// ---------------- All Group Btn Event ---------------- //

- (IBAction)allGroupBtn:(id)sender {
    nowGroup = 0;
    
    [self reloadTableView];
}



// ---------------- Add Group Btn Event ---------------- //

- (IBAction)addGroupBtn:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"그룹 생성" message:nil delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"이름을 입력하세요";
    alert.tag = GroupAddTag;
    
    [alert show];
}



// ---------------- Group Set ---------------- //

-(void)setGroup{
    // ScrollView Sub Button Remove
    while ([groupScrollView.subviews count] > 2) {
        [[groupScrollView.subviews lastObject] removeFromSuperview];
    }
    groupArray = [db getGroupIds];
    
    if (groupArray.count != 0) {
        for(int i = 0; i < groupArray.count; i++){
            [self addGroup:[db getGroupName:[[groupArray objectAtIndex: i] integerValue]]:i];
        }
    }

}


// ---------------- Add Group Btn ---------------- //

-(void)addGroup:(NSString *)folderName:(int)groupCount{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(5.0f, (groupCount + 1) * 50.0f + ( groupCount * 6.0f ) + 6.0f, 50.0f, 50.0f)];
    [button setTitle:folderName forState:UIControlStateNormal];
    [button setTag:[[groupArray objectAtIndex:groupCount] intValue]];
    
    [button addTarget:self action:@selector(groupBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    [groupScrollView addSubview:[self setBtnStyle:button]];
    
    [groupScrollView setContentSize:CGSizeMake(70.0f, (groupCount + 1) * 50.0f + ( groupCount * 6.0f) + 6.0f + 6.0f + 50.0f)];
    
    
    [addGroupBtn setFrame:CGRectMake(5.0f, (groupCount + 2) * 50.0 + ( groupCount * 6.0) + 6.0f, 50.0f, 50.0f)];
}



// ---------------- Set Group Btn Style ---------------- //

-(UIButton *)setBtnStyle:(UIButton *)btn{
    
    [btn setBackgroundImage:allGroupBtn.currentBackgroundImage forState:UIControlStateNormal];
    [btn setTitleColor:allGroupBtn.currentTitleColor forState:UIControlStateNormal];
    [btn setTitleShadowColor:allGroupBtn.currentTitleShadowColor forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:allGroupBtn.titleEdgeInsets];
    btn.titleLabel.shadowOffset = allGroupBtn.titleLabel.shadowOffset;
    btn.titleLabel.font = allGroupBtn.titleLabel.font;
    
    return btn;
}


// ---------------- Group Btn Event ---------------- //

- (void)groupBtnClickEvent:(UIButton *)btn{
//    NSLog(@"%d",btn.tag);
    
//    if (!edit) {
        if (nowGroup == btn.tag) {
            NSLog(@"Double Clikc");
        }else{
            nowGroup = btn.tag;
            [self reloadTableView];
        }
//    }
}





#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];

//    if (!edit) {
        //        NSLog(@"setTable False");
        BcTableCell *bcTableCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
        if(bcTableCell == nil){
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BcTableCell" owner:nil options:nil];
            
            bcTableCell = [array objectAtIndex:0];
            bcTableCell.frame = CGRectMake(0, 0, 0, 0 );
            
        }

        //        NSLog(@"BC count ===  %d", bcArray.count);
        
        for (int i = 0; i < bcArray.count; i++) {
            if(index == i){
                dStruct =[db getData:[[bcArray objectAtIndex:i]intValue]];
                bcTableCell.nameLabel.text = dStruct.name;
                bcTableCell.numberLabel.text = dStruct.number;
                bcTableCell.emailLabel.text = dStruct.email;
                [self loadImg:[bcArray objectAtIndex:i] :bcTableCell.cardImg];
            }
        }
    
    return bcTableCell;
}




// ---------------- BusinessCard Reload ---------------- //

-(void)reloadTableView{
    
    if (nowGroup == 0) {
        bcArray = [db getBcIds];
    }else {
        bcArray = [db getMemberIds:nowGroup];
    }
    [businessCardTable reloadData];
}

// ---------------- Load Image ---------------- //

-(void)loadImg:(NSString *)fileName:(UIImageView *)imageView{
    NSString *file = [NSString stringWithFormat:@"%@.png",fileName];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // 파일명을 붙여서...
    NSString *imagePath1 = [documentsDirectory stringByAppendingPathComponent:file];
    
    // 각각의 이미지를 읽어 원하는 곳에 사용합니다.
    UIImage *useImage1 = [UIImage imageWithContentsOfFile:imagePath1];
    
    imageView.image = useImage1;
}


// ---------------- Section Count ---------------- //

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bcArray.count;
}



#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == GroupAddTag) {
        if (buttonIndex == 0) {
            NSLog(@"Cancel");
        }else {
            NSString *temp =
            [[NSString alloc]initWithFormat:@"%@",[alertView textFieldAtIndex:0].text];
            [db groupInsert:temp];
            [self setGroup];
        }
    }else if(alertView.tag == GroupEditTag){
        if (buttonIndex == 0) {
            NSLog(@"GroupEditTag Cancel");
        }else {
            NSLog(@"OK");
        }
    }else if(alertView.tag == GroupDelTag){
        if(buttonIndex == 0){
            NSLog(@"GroupDelTag Cancel");
        }else {
            NSLog(@"OK");
        }
    }else if(alertView.tag == CardDelTag){
        if (buttonIndex == 0) {
            NSLog(@"Cancel");
        }else{
            NSLog(@"CardDelTag OK");
        }
        
    }
    
}



// ---------------- ActionSheet Event ---------------- //

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == CardAddTag) {
        if (buttonIndex == 0) {
            NSLog(@"사진 찍기");
            
            editBcViewController = [[EditBcViewController alloc]init];
            
            
            [editBcViewController setCardImg:[UIImage imageNamed:@"blue.png"]:@"이름":@"12345":@"email@email.com":0:0:0:0:0:0:0:0:0:0:0:0];
            
            [self.view insertSubview:editBcViewController.view aboveSubview:self.view];
        }else if(buttonIndex == 1){
            NSLog(@"앨범에서 불러오기");
        }else if(buttonIndex == 2){
            NSLog(@"주소록에서 가져오기");
        }else if(buttonIndex == 3){
          NSLog(@"직접 입력하기");
            selectView = [[SelectViewController alloc]init];
            [self.view insertSubview:selectView.view aboveSubview:self.view];
        }
    }
}
@end
