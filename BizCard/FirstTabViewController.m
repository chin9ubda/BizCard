//
//  FirstTabViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "FirstTabViewController.h"
#import "SelectBCTemplateViewController.h"
#import "BcTableCell.h"
#import "DataStruct.h"
#import "MsgLoadViewController.h"
#import "OverlayView.h"
#import "ScanViewController.h"
#import <AddressBook/AddressBook.h>

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

#define SortLastInsert 0
#define SortName 1
#define SortMostClick 0

//----------------------------------------------------------------------------------------
// Overlay View
//----------------------------------------------------------------------------------------
//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
//#define CAMERA_TRANSFORM_Y 1.12412
#define CAMERA_TRANSFORM_Y 1
//----------------------------------------------------------------------------------------


@interface FirstTabViewController ()

@end

@implementation FirstTabViewController
@synthesize allGroupBtn;
@synthesize addGroupBtn;
@synthesize groupScrollView;
@synthesize businessCardTable;
@synthesize editBtn;
@synthesize searchTextField;
@synthesize tookPicture;


/* -----------------------------------------------------
   DataBase Class getInstance;
   edit == false  :  보통 상태
   nowState == CardEdit  :  카드 편집 상태
   nowState == MemberEdit  :  맴버 편집 상태
   ------------------------------------------------------- */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [DataBase getInstance];
        dStruct = [[DataStruct alloc]init];
        [self reloadTableView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarMake" object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dismiss_type = VIEW;
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
    [self setEditBtn:nil];
    [self setSearchTextField:nil];
    [self setTookPicture:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


// ---------------- addBCBtn Event ---------------- //
// --------------- show ActionSheet --------------- //
- (IBAction)addBCBtn:(id)sender {
    
    if (!edit) {
        UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"취소"
                                      destructiveButtonTitle:@"사진 촬영"
                                      otherButtonTitles:@"앨범에서 가져오기", @"주소록에서 가져오기", @"직접 입력하기", nil];
        actionsheet.tag = CardAddTag;
        [actionsheet showInView:self.view];
    }
}


// ---------------- Card Edit Btn Event ---------------- //

/* -----------------------------------------------------
     edit == true  :  현제 체크박스 노출 상태
     edit == false  :  보통 상태
     nowState == CardEdit  :  카드 편집 상태
     nowState == MemberEdit  :  맴버 편집 상태
 ------------------------------------------------------- */

- (IBAction)editBCBtn:(id)sender{
    if (edit) {
        if (nowState == CardEdit) {
            for (int i = 0; i < bcCheckArray.count; i++) {
                if ([[bcCheckArray objectAtIndex: i] integerValue] != 0) {
//                    NSLog(@"%d",[[bcArray objectAtIndex: i] integerValue]);
                }
            }
            [cMenu removeFromSuperview];
        }else if (nowState == MemberEdit){
            
            [db memberDel:nowGroup];
            for(int i = 0; i < bcCheckArray.count; i++){
                if ([[bcCheckArray objectAtIndex: i] integerValue] != 0) {
                    [db memberUpdate:nowGroup :[[bcArray objectAtIndex:i]integerValue]];
                }
            }
            
            [gMenu removeFromSuperview];
            gMenu = nil;
        }
        edit = false;
//        [editBtn setTitle:@"편집" forState:UIControlStateNormal];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"main_top_edit1_62_72.png"] forState:UIControlStateNormal];

        [self reloadTableView];

    }else{
        if (bcArray.count != 0) {
//            [editBtn setTitle:@"완료" forState:UIControlStateNormal];
            [editBtn setBackgroundImage:[UIImage imageNamed:@"main_top_edit2_62_72.png"] forState:UIControlStateNormal];
            edit = true;
            nowState = CardEdit;
            [self reloadTableView];
            clickCount = 0;

        }
    }
}


// ---------------- Sort Change ---------------- //

- (IBAction)sortBtn:(id)sender {
    if (sortType == SortLastInsert) {
        sortType = SortName;
    }else if (sortType == SortName) {
        sortType = SortLastInsert;
    }
    
    [self reloadTableView];
}



// ---------------- All Group Btn Event ---------------- //

- (IBAction)allGroupBtn:(id)sender {
    search = false;
    [sender setTag:0];
    [self groupBtnClickEvent:sender];
}



// ---------------- Add Group Btn Event ---------------- //

- (IBAction)addGroupBtn:(id)sender {
    if (!edit) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"그룹 생성" message:nil delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeDefault;
        alertTextField.placeholder = @"이름을 입력하세요";
        alert.tag = GroupAddTag;
        
        [alert show];
    }
    search = false;
    [gMenu removeFromSuperview];
}



- (void)peoplePickerShow
{
    ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];

}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    
    NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));
    NSString *secondName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty));
    
    ABMultiValueRef numberValue = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFStringRef number = ABMultiValueCopyValueAtIndex(numberValue, 0);
    
    ABMultiValueRef emailValue = ABRecordCopyValue(person, kABPersonEmailProperty);
    CFStringRef email = ABMultiValueCopyValueAtIndex(emailValue, 0);

    
    SelectBCTemplateViewController *select = [[SelectBCTemplateViewController alloc]init];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:select animated:YES];
    [select setData:(NSString *) [NSString stringWithFormat:@"%@ %@",firstName,secondName] :[NSString stringWithFormat:@"%@",number] :[NSString stringWithFormat:@"%@",email]];
    
    return NO;
}


// ------------------------------ Group Set ------------------------------ //

/* -----------------------------------------------------------------------
     Group ScrollView 에서 기존에 있는 '전체 보기' 추가하기 외의 버튼을 삭제하고
     데이터 베이스에서 데이터를 불러와 새로 그룹을 만듬
   ----------------------------------------------------------------------- */

-(void)setGroup{
    
    if (groupBtnArray != nil) {
        groupBtnArray = nil;
    }
    
    groupBtnArray = [NSMutableArray arrayWithCapacity:0];
    
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


// ------------------------------ Add Group ------------------------------ //

/* -----------------------------------------------------------------------
     groupName ( 그룹이름 ) 과 현재 몇번째 버튼을 추가 하고 있는지 ( groupCount )
     입렵을 받아 groupCount 의 값만큼 계산을 하여 그룹 버튼의 위치를 잡고 생성,
     기존에 AddGroupBtn 의 위치를 수정
   ----------------------------------------------------------------------- */

-(void)addGroup:(NSString *)groupName:(int)groupCount{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(5.0f,(groupCount + 1) * 40.0f + (groupCount + 1) * 6.0f, 75.0f, 40.0f)];
    [button setTitle:groupName forState:UIControlStateNormal];
//    [button setTag:[[groupArray objectAtIndex:groupCount] intValue]];
    
    [button setTag:groupCount + 1];

    
    [button addTarget:self action:@selector(groupBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    [groupScrollView addSubview:[self setBtnStyle:button]];
    
    [addGroupBtn setFrame:CGRectMake(5.0f, (groupCount + 2) * 40.0f + (groupCount + 2) * 6.0f, 75.0f, 40.0f)];
    
    [groupBtnArray addObject:button];
}



// ---------------- Set Group Btn Style ---------------- //

/* -----------------------------------------------------
     그룹 버튼을 입력받아 그룹 버튼의 스타일을 적용한후 리턴
   ----------------------------------------------------- */

-(UIButton *)setBtnStyle:(UIButton *)btn{
    
    [btn setBackgroundImage:addGroupBtn.currentBackgroundImage forState:UIControlStateNormal];
    [btn setTitleColor:addGroupBtn.currentTitleColor forState:UIControlStateNormal];
    btn.titleLabel.font = addGroupBtn.titleLabel.font;
    
    return btn;
}


// ------------------ Group Btn Event ------------------ //

/* -----------------------------------------------------
     그룹 버튼이 테그로 구분이 되며, 해당 그룹을 클릭하였을 경우,
     한번 클릭했을 경우 현제 그룹 상태를 나타내는 nowGroup 의
     값을 현제 그룹의 _id 값으로 변경해주고, 그룹 메뉴를 없애고
     테이블을 reload 한다.
     버튼의 테그와 테그번째의 그룹의 _id 값을 비교하여,
     지금 선택된 그룹의 상태를 확인하고 선택된 이미지의 버튼과
     다른 버튼의 이미지를 비교되도록 적용시킨다.
   ----------------------------------------------------- */

- (void)groupBtnClickEvent:(UIButton *)btn{
    if (!edit) {                                                    // 체크박스 노출 상태일 경우
        if (btn.tag == 0){                                    // 지금 선택된 버튼의 테그가 0 번.. 즉 ALL 버튼
            if (btn.tag != nowGroup) {                        // 이며 이전에 선택되지 않았을 경우
                [allGroupBtn setBackgroundImage:[UIImage imageNamed:@"main_black_bar_select_white_164_84.png"] forState:UIControlStateNormal];
                for (int i = 0; i < groupBtnArray.count; i++) {
                    [[groupBtnArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"main_black_bar_box_navy_152_84.png"] forState:UIControlStateNormal];
                }
                nowGroup = 0;
                [gMenu removeFromSuperview];
                [self reloadTableView];
            }
        }else if (nowGroup == [[groupArray objectAtIndex:btn.tag - 1] intValue]) {      // 이전에 선택된 그룹과 지금 클릭한 버튼의 _id 값이 같을경우
            [gMenu removeFromSuperview];
            [self groupMenu];
        }else if (nowGroup != [[groupArray objectAtIndex:btn.tag - 1] intValue]){       // 이전에 선택한 버튼과 다른 버튼을 선택했으며, 선택된 버튼이 ALL 버튼이 아닐경우
            [allGroupBtn setBackgroundImage:[UIImage imageNamed:@"main_black_bar_box_navy_152_84.png"] forState:UIControlStateNormal];
            
            for (int i = 0; i < groupBtnArray.count; i++) {
                if ((btn.tag - 1) == i)
                    [[groupBtnArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"main_black_bar_select_white_164_84.png"] forState:UIControlStateNormal];
                else
                    [[groupBtnArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"main_black_bar_box_navy_152_84.png"] forState:UIControlStateNormal];

            }
            
            nowGroup = [[groupArray objectAtIndex:btn.tag - 1] intValue];
            [gMenu removeFromSuperview];
            [self reloadTableView];
        }
    }
    search = false;
}




// ---------------- Group Menu Opne & setting ---------------- //


-(void)groupMenu{
    
    nowState = GroupEditTag;
    
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"Group_Menu" owner:self options:nil];
    gMenu = (Group_Menu *)[xibs objectAtIndex:0];
    [gMenu awakeFromNib];
    gMenu.frame = CGRectMake(68, 240, 372, 60);
    
    [self.view addSubview:gMenu];
    
    [gMenu.groupSmsBtn addTarget:self action:@selector(groupSms) forControlEvents:UIControlEventTouchUpInside];
    [gMenu.groupEmailBtn addTarget:self action:@selector(groupEmail) forControlEvents:UIControlEventTouchUpInside];
    [gMenu.groupMemberEditBtn addTarget:self action:@selector(groupMember) forControlEvents:UIControlEventTouchUpInside];
    [gMenu.groupNameEditBtn addTarget:self action:@selector(groupEdit) forControlEvents:UIControlEventTouchUpInside];
    [gMenu.groupDelBtn addTarget:self action:@selector(groupDel) forControlEvents:UIControlEventTouchUpInside];
}




// ---------------- Group Menu Opne & setting ---------------- //

-(void)groupSms{
    if (bcArray.count != 0) {
        UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"취소"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"메시지 불러오기", @"새로쓰기", nil];
        actionsheet.tag = GroupSms;
        [actionsheet showInView:self.view];
        
        [gMenu removeFromSuperview];
    }

}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
}

-(void)groupEmail{
    if (bcArray.count != 0) {
        UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"취소"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"메시지 불러오기", @"새로쓰기", nil];
        actionsheet.tag = GroupEmail;
        [actionsheet showInView:self.view];
        
        [gMenu removeFromSuperview];
    }
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];

}

-(void)groupMember{
    if (!edit) {
//        [editBtn setTitle:@"완료" forState:UIControlStateNormal];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"main_top_edit2_62_72.png"] forState:UIControlStateNormal];

        nowState = MemberEdit;
        edit = true;
        
        NSArray *checkAr = bcArray;
        
        bcArray = [db getBcIds:sortType];
        
        if (bcCheckArray != nil) {
            bcCheckArray = nil;
        }

        
        bcCheckArray = [NSMutableArray arrayWithCapacity:0];
        
        
        for (int i = 0; i < bcArray.count; i++) {
            [bcCheckArray insertObject: [NSNumber numberWithInteger: 0] atIndex:i];
        }
        
        for (int i = 0; i < checkAr.count; i++) {
            int j = 0;
            while ([[checkAr objectAtIndex:i]integerValue] != [[bcArray objectAtIndex:j]integerValue]) {
                j++;
            }
                
            [bcCheckArray replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger: 1]];
        }
            
        checkAr = nil;
        
        [businessCardTable reloadData];
    }
    [gMenu removeFromSuperview];
}

-(void)groupEdit{
    NSString *name = [db getGroupName:nowGroup];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"이름 변경" message:nil delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"이름을 입력하세요";
    
    alertTextField.text = name;
    
    [alert show];
    
    alert.tag = GroupEditTag;
    
    [gMenu removeFromSuperview];
}

-(void)groupDel{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"확  인" message:@"정말 삭제하시겠습니까?" delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
    alert.tag = GroupDelTag;
    
    [gMenu removeFromSuperview];
}



// ---------------- Card Menu Opne & setting ---------------- //

-(void)cardMenu{
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"Card_Menu" owner:self options:nil];
    cMenu = (Card_Menu *)[xibs objectAtIndex:0];
    [cMenu awakeFromNib];
    cMenu.frame = CGRectMake(68, 240, 372, 60);
    [self.view addSubview:cMenu];
    
    [cMenu.smsBtn addTarget:self action:@selector(cardSms) forControlEvents:UIControlEventTouchUpInside];
    [cMenu.emailBtn addTarget:self action:@selector(cardEmail) forControlEvents:UIControlEventTouchUpInside];
    [cMenu.delBtn addTarget:self action:@selector(cardDel) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)cardSms{
    NSLog(@"cardSms");
    UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"취소"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"메시지 불러오기", @"새로쓰기", nil];
    actionsheet.tag = CardSms;
    [actionsheet showInView:self.view];
    
//    [cMenu removeFromSuperview];
}
-(void)cardEmail{
    NSLog(@"cardEmail");
    UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"취소"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"메시지 불러오기", @"새로쓰기", nil];
    actionsheet.tag = CardEmail;
    [actionsheet showInView:self.view];
    
}
-(void)cardDel{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"확  인" message:@"정말 삭제하시겠습니까?" delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
    alert.tag = CardDelTag;
}


// ---------------- BusinessCard Reload ---------------- //

-(void)reloadTableView{
    
    if (nowGroup == 0 && !search) {
        bcArray = [db getBcIds:sortType];
    }else if (nowGroup != 0){
        bcArray = [db getMemberIds:nowGroup:sortType];
    }
    
    if (bcCheckArray != nil) {
        bcCheckArray = nil;
    }
    
    
    bcCheckArray = [NSMutableArray arrayWithCapacity:0];
    

    for (int i = 0; i < bcArray.count; i++) {
        [bcCheckArray insertObject: [NSNumber numberWithInteger: 0] atIndex:i];
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



// ---------------- TableViewCell Setting ---------------- //

#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BcTableCell *bcTableCell;
    
    if (bcTableCell != nil) {
        bcTableCell = nil;
    }
    
    int index = [indexPath row];
    
    if (edit) {
        
        bcTableCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
        if(bcTableCell == nil){
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BcTableCell" owner:nil options:nil];
            
            bcTableCell = [array objectAtIndex:0];
//            [self moveView:bcTableCell.cardView duration:0.3 curve:UIViewAnimationCurveLinear x:40 y:0];
            bcTableCell.cardView.frame = CGRectMake(40, 0, bcTableCell.frame.size.width, bcTableCell.frame.size.height);
            bcTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        dStruct =[db getData:[[bcArray objectAtIndex:index]intValue]];
        bcTableCell.nameLabel.text = dStruct.name;
        bcTableCell.numberLabel.text = dStruct.number;
        bcTableCell.emailLabel.text = dStruct.email;
        [self loadImg:[bcArray objectAtIndex:index] :bcTableCell.cardImg];

        if([[bcCheckArray objectAtIndex: index] integerValue] == 1){
            [bcTableCell.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        }else if([[bcCheckArray objectAtIndex: index] integerValue] == 0){
            [bcTableCell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        }
        
    }else {
        bcTableCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
        if(bcTableCell == nil){
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BcTableCell" owner:nil options:nil];
            
            bcTableCell = [array objectAtIndex:0];
            bcTableCell.frame = CGRectMake(0, 0, 0, 0 );
            bcTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        dStruct =[db getData:[[bcArray objectAtIndex:index]intValue]];
        bcTableCell.nameLabel.text = dStruct.name;
        bcTableCell.numberLabel.text = dStruct.number;
        bcTableCell.emailLabel.text = dStruct.email;
        [self loadImg:[bcArray objectAtIndex:index] :bcTableCell.cardImg];
    }
        
    return bcTableCell;
}




// ---------------- Section Count Setting ---------------- //

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bcArray.count;
}



// ---------------- Cell Select Event ---------------- //

/* ---------------------------------------------------------------
   edit == true 일경우 ( 체크박스 노출 상태 )
     nowState == CardEdit 체크박스 이미지 변경, bcCheckArray 수정,
               clickCout 1개 이상일경우 메뉴보임
     nowState == MemberEdit 체크박스 이미지 변경, bcCheckArray 수정
   edit == false 일경우 ( 체크박스 비노출 )
     카드 자세히 보기 화면으로 이동
  --------------------------------------------------------------- */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int index = [indexPath row];
        
    if (edit) {
        if (nowState == CardEdit) {
            
            BcTableCell *cell = (BcTableCell *)[businessCardTable cellForRowAtIndexPath:indexPath];

            
            if ([[bcCheckArray objectAtIndex: index] integerValue] == 0) {
                [bcCheckArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 1]];
                [cell.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                clickCount++;
            }else{
                [bcCheckArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 0]];
                [cell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
                clickCount--;
            }
            
            if (clickCount > 0) {
                [cMenu removeFromSuperview];
                [self cardMenu];
            }else if(clickCount <= 0){
                [cMenu removeFromSuperview];
            }
            
        }else if (nowState == MemberEdit){
            
            BcTableCell *cell = (BcTableCell *)[businessCardTable cellForRowAtIndexPath:indexPath];
            
            
            if ([[bcCheckArray objectAtIndex: index] integerValue] == 0) {
                [bcCheckArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 1]];
                [cell.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
            }else{
                [bcCheckArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 0]];
                [cell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
            }
        }
    }else{
        bcView = [[BCViewController alloc]init];
        [bcView setImg:[[bcArray objectAtIndex:index]integerValue]];
        
        [gMenu removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
        [self presentModalViewController:bcView animated:YES];
    }
    
}



// ------------------------- Msg Load ------------------------- //

/* ---------------------------------------------------------------
   MsgLoadViewController presentModalView
   Send Array;
   SetType
     - type = 0 : SMS
     - type = 1 : EMAIL
   --------------------------------------------------------------- */

-(void)msgLoadView:(NSArray *)array:(int)type{
    MsgLoadViewController *msgLoad = [[MsgLoadViewController alloc]init];
    [msgLoad setArray:array];
    [msgLoad setType:type];
    
    array = nil;
    
    [self presentModalViewController:msgLoad animated:YES];

}


// ------------------------- Sms Send ------------------------- //

/* ---------------------------------------------------------------
   Message Send
   MFMessageComposeViewController presentModalView
   --------------------------------------------------------------- */

-(void)smsSend:(NSArray *)array{
    MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
    smsController.messageComposeDelegate = self;
    if([MFMessageComposeViewController canSendText])
    {
        smsController.body = nil;
        [smsController setRecipients:array];
        smsController.messageComposeDelegate = self;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
        [self presentModalViewController:smsController animated:YES];
    }
}


// ------------------------- Email Send ------------------------- //

/* ---------------------------------------------------------------
   Message Send
   MFMessageComposeViewController presentModalView
   --------------------------------------------------------------- */

-(void)emailSend:(NSArray *)array{
    MFMailComposeViewController *mailsome = [[MFMailComposeViewController alloc] init];
    mailsome.mailComposeDelegate=self;
    if([MFMailComposeViewController canSendMail]){
        [mailsome setToRecipients:array];
        [mailsome setSubject:nil];
        [mailsome setMessageBody:nil isHTML:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
        [self presentModalViewController:mailsome animated:YES];
    }
}



// ------------------------ TextField Setting ------------------------ //


// ------- TextField 'Retrun' Key Event ------- //

/* --------------------------------------------
   검색, 키보드 감추기
   -------------------------------------------- */

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if ([textField.text isEqualToString:@""]) {
        [self allGroupBtn:allGroupBtn];
    }else {
        bcArray = [db search:textField.text :sortType];
        
        search = true;
        
        [self reloadTableView];
    }
    return NO;
}



// --------- TextField BeginEditing --------- //

/* ------------------------------------------
   TextField Edit 실행시. searchTextField 공백
   ------------------------------------------ */

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
//    searchTextField.text = @"";
    
    nowGroup = 0;
    
    if (edit) {
        if (nowState == CardEdit) {
            [cMenu removeFromSuperview];
        }else{
            
            [gMenu removeFromSuperview];
            gMenu = nil;
        }
    }
    
    return YES;
}



// -------- TextField EndEditing -------- //

/* --------------------------------------
 TextField Edit 실행시. 각 Label 값 변경
 -------------------------------------- */


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    searchTextField.text = @"";
    
    return YES;
}


// ------------------------- Alert Event ------------------------- //

/* ---------------------------------------------------------------
   tag == GroupAddTag  : 그룹 추가 - TextField 에 입력된 값으로 그룹 추가
   tag == GroupEditTag : 그룹 편집 - TextField 에 입력된 값으로 그룹 변경
   tag == GroupDelTag : 그룹 삭제 확인 Alert
   tag == CardDelTag : 카드 삭제 확인 Alert
   --------------------------------------------------------------- */

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
            NSString *temp =
            [[NSString alloc]initWithFormat:@"%@",[alertView textFieldAtIndex:0].text];
            [db groupUpdate:nowGroup :temp];
            
            [gMenu removeFromSuperview];
            
            [self setGroup];
        }
    }else if(alertView.tag == GroupDelTag){
        if(buttonIndex == 0){
            NSLog(@"GroupDelTag Cancel");
        }else {
            [db groupDel:nowGroup];
            [db memberDel:nowGroup];
            [gMenu removeFromSuperview];
            [self setGroup];
        }
    }else if(alertView.tag == CardDelTag){
        if (buttonIndex == 0) {
            NSLog(@"Cancel");
        }else{
            for(int i = 0; i < bcCheckArray.count; i++){
                if([[bcCheckArray objectAtIndex: i] integerValue] == 1){
                    [db bcDel: [[bcArray objectAtIndex:i]integerValue]];
                    
                    
                    NSString *file = [NSString stringWithFormat:@"%d.png",[[bcArray objectAtIndex:i]integerValue]];
                    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                    
                    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:file];
                    NSFileManager *fm = [NSFileManager defaultManager];
                    
                    [fm removeItemAtPath:imagePath error:nil];
                    
                }
            }
            [self reloadTableView];
            [cMenu removeFromSuperview];
        }
        
    }
    
}

// ---------------- ActionSheet Event ---------------- //

/* -----------------------------------------------------
   tag == CardAddTag  : 명함 추가 방법 선택
   tag == GroupEmail : 그룹 이메일
   tag == GroupSms : 그룹 SMS
   tag == CardEmail : 선택된 명함 이메일
   tag == CardSms : 선택된 명함 SMS
                    - 메시지 불러오기 : 기존 메시지를 불러오기위한 MsgLoadViewController 호출
                    - 새로쓰기 : 이메일 전송 ViewController 호출
   ----------------------------------------------------- */
#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == CardAddTag) {
        if (buttonIndex == 0) {
            NSLog(@"사진 찍기");
            
            /*
            editBcViewController = [[EditBcViewController alloc]init];
            DataStruct *pushData = [[DataStruct alloc]init];
            
            pushData.name = @"이름";
            pushData.number = @"123";
            pushData.email = @"123@123.com";
            
            [editBcViewController setCardImg:0:[UIImage imageNamed:@"blue.png"]:pushData];
            pushData = nil;
            
            [self presentModalViewController:editBcViewController animated:YES];
            */
            
            imagepickerController = [[UIImagePickerController alloc] init];
            [imagepickerController setDelegate:self];
            
            [imagepickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            NSArray *xibs = [[NSBundle mainBundle]  loadNibNamed:@"OverlayView" owner:self options:nil];
            OverlayView *overlay = (OverlayView *)[xibs objectAtIndex:0];
            
            imagepickerController.allowsEditing=NO;
            imagepickerController.showsCameraControls = NO;
            imagepickerController.cameraViewTransform = CGAffineTransformScale(imagepickerController.cameraViewTransform,CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
            
            imagepickerController.cameraOverlayView = overlay;
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
            [self presentModalViewController:imagepickerController animated:YES];
            
        }else if(buttonIndex == 1){
            NSLog(@"앨범에서 불러오기");
           
            imagepickerController = [[UIImagePickerController alloc] init];
            [imagepickerController setDelegate:self];
            [imagepickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
            [self presentModalViewController:imagepickerController animated:YES];

            /*
            editBcViewController = [[EditBcViewController alloc]init];
            
            DataStruct *pushData = [[DataStruct alloc]init];
            
            pushData.name = @"이름";
            pushData.number = @"123";
            pushData.email = @"123@123.com";
            
            [editBcViewController setCardImg:0:[UIImage imageNamed:@"blue.png"]:pushData];
            pushData = nil;

            [self presentModalViewController:editBcViewController animated:YES];
             */
            
        }else if(buttonIndex == 2){
//            NSLog(@"주소록에서 가져오기");
            [self peoplePickerShow];
        }else if(buttonIndex == 3){
          NSLog(@"직접 입력하기");
            selectView = [[SelectBCTemplateViewController alloc]init];
            [self presentModalViewController:selectView animated:YES];
        }
    }else if (actionSheet.tag == GroupEmail){
        if (buttonIndex == 0) {
            DataStruct *getData;
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < bcArray.count; i++) {
                getData =[db getData:[[bcArray objectAtIndex:i]intValue]];
                [array insertObject:getData.email  atIndex:i];
            }
            getData = nil;
            
            [self msgLoadView:array:1];
            array = nil;
            
        }else{
            DataStruct *getData;
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < bcArray.count; i++) {
                getData =[db getData:[[bcArray objectAtIndex:i]intValue]];
                [array insertObject:getData.email  atIndex:i];
            }
            getData = nil;
            
            [self emailSend:array];
            
            array = nil;
        }
    }else if (actionSheet.tag == GroupSms){
        if (buttonIndex == 0) {
            DataStruct *getData;
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < bcArray.count; i++) {
                getData =[db getData:[[bcArray objectAtIndex:i]intValue]];
                [array insertObject:getData.number  atIndex:i];
            }
            getData = nil;
            
            [self msgLoadView:array:0];

            array = nil;
        }else{
            DataStruct *getData;
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < bcArray.count; i++) {
                getData =[db getData:[[bcArray objectAtIndex:i]intValue]];
                
                [array insertObject:getData.number  atIndex:i];
            }
            getData = nil;
            
            [self smsSend:array];
            
            array = nil;
        }

    }else if (actionSheet.tag == CardEmail){
        if (buttonIndex == 0) {
            DataStruct *getData;
            int count = 0;
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < bcArray.count; i++) {
                if ([[bcCheckArray objectAtIndex: i] integerValue] != 0) {
                    getData =[db getData:[[bcArray objectAtIndex:i]intValue]];
                    [array insertObject:getData.email  atIndex:count];
                    count++;
                }
            }
            getData = nil;
            
            [self msgLoadView:array:1];
            
            array = nil;
            
        }else{
            
            DataStruct *getData;
            int count = 0;
            
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
            
            for(int i = 0; i < bcCheckArray.count; i++){
                if ([[bcCheckArray objectAtIndex: i] integerValue] != 0) {
                    getData =[db getData:[[bcArray objectAtIndex:i]intValue]];
                    [array insertObject:getData.email  atIndex:count];
                    count++;
                }
            }
            
            getData = nil;

            [self emailSend:array];

            array = nil;
        }
        
    }else if (actionSheet.tag == CardSms){
        if (buttonIndex == 0) {
            DataStruct *getData;
            int count = 0;
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < bcArray.count; i++) {
                if ([[bcCheckArray objectAtIndex: i] integerValue] != 0) {
                    getData =[db getData:[[bcArray objectAtIndex:i]intValue]];
                    [array insertObject:getData.number  atIndex:count];
                    count++;
                }
            }
            getData = nil;
            
            [self msgLoadView:array:0];
            
            array = nil;
        }else{
            DataStruct *getData;
            int count = 0;
            
            NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < bcArray.count; i++) {
                if ([[bcCheckArray objectAtIndex: i] integerValue] != 0) {
                    getData =[db getData:[[bcArray objectAtIndex:i]intValue]];
                    [array insertObject:getData.number  atIndex:count];
                    count++;
                }
            }
            getData = nil;
            
            [self smsSend:array];
            
            array = nil;
        }
        
    }
}

// 사진 고르기 취소
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

// 사진 찍기 버튼 눌렀을 때
- (IBAction)tookPicture:(id)sender {
    [imagepickerController takePicture];
    SJ_DEBUG_LOG(@"Take Picture");
}


// 3. 가지고 온 사진을 편집한다 (crop, 회전 등)
#pragma mark UIImagePickerContoller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    SJ_DEBUG_LOG(@"Image Selected");
    if(imagepickerController.sourceType == UIImagePickerControllerSourceTypeCamera){
        dismiss_type = IMAGEPICKER_CAMERA;
    }else{
        dismiss_type = IMAGEPICKER_PHOTO_ALBUM;
    }
    
    scanImage = image;
    [picker dismissModalViewControllerAnimated:NO];
    
    return;
}


-(void)viewDidAppear:(BOOL)animated{
    
    //Scan 화면으로 갈때
    if(dismiss_type == IMAGEPICKER_PHOTO_ALBUM || dismiss_type == IMAGEPICKER_CAMERA){
        [self goScanView:dismiss_type];
        dismiss_type = VIEW;
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    }
}

-(void)goScanView:(int)type{
    
    ScanViewController *scanViewCont = [ScanViewController new];
    [self presentModalViewController:scanViewCont animated:YES];
    //[self.view insertSubview:scanViewCont.view aboveSubview:self.view];
    [scanViewCont initView:scanImage type:type];
}

@end
