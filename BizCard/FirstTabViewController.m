//
//  FirstTabViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "FirstTabViewController.h"
#import "SelectViewController.h"
#import "BcTableCell.h"

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
@synthesize editBtn;

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
    [self setEditBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


- (IBAction)editBCBtn:(id)sender{
    if (edit) {
        if (nowState == CardEdit) {
            for (int i = 0; i < bcCheckArray.count; i++) {
                if ([[bcCheckArray objectAtIndex: i] integerValue] != 0) {
                    NSLog(@"%d",[[bcArray objectAtIndex: i] integerValue]);
                }
            }
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
        editBtn.title = @"편집";
        [self reloadTableView];

    }else{
        if (bcArray.count != 0) {
            editBtn.title = @"완료";
            edit = true;
            nowState = CardEdit;
            [self reloadTableView];

        }
    }
}



// ---------------- All Group Btn Event ---------------- //

- (IBAction)allGroupBtn:(id)sender {
//    nowGroup = 0;
    [sender setTag:0];
    [self groupBtnClickEvent:sender];
//    
//    [self reloadTableView];
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
    
    if (!edit) {
        if (nowGroup == btn.tag) {
            if (btn.tag != 0) {
                [gMenu removeFromSuperview];
                [self groupMenu];
            }
        }else{
            
            nowGroup = btn.tag;
            [gMenu removeFromSuperview];
            [self reloadTableView];
        }
    }else {
        
    }
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
    NSLog(@"groupSms");
}

-(void)groupEmail{
    NSLog(@"groupEmail");
}

-(void)groupMember{
    if (!edit) {
        [editBtn setTitle:@"완료"];
        nowState = MemberEdit;
        edit = true;
        
        NSArray *checkAr = bcArray;
        
        bcArray = [db getBcIds];
        
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
        
//        [self initData:0];
//        [self reloadTableView];
//
//        for (int i = 0; i < checkAr.count; i++) {
//            int j = 0;
//            while ([[checkAr objectAtIndex:i]integerValue] != [[bcArray objectAtIndex:j]integerValue]) {
//                j++;
//            }
//            
//            [checkArray replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger: 1]];
//        }
//        
//        
    }
//    [businessCardTable reloadData];
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



// ---------------- BusinessCard Reload ---------------- //

-(void)reloadTableView{
    
    if (nowGroup == 0) {
        bcArray = [db getBcIds];
    }else {
        bcArray = [db getMemberIds:nowGroup];
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
            bcTableCell.cardView.frame = CGRectMake(40, 0, bcTableCell.frame.size.width, bcTableCell.frame.size.height);
            bcTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        dStruct =[db getData:[[bcArray objectAtIndex:index]intValue]];
        bcTableCell.nameLabel.text = dStruct.name;
        bcTableCell.numberLabel.text = dStruct.number;
        bcTableCell.emailLabel.text = dStruct.email;
        [self loadImg:[bcArray objectAtIndex:index] :bcTableCell.cardImg];

        if (nowState == MemberEdit) {
            if([[bcCheckArray objectAtIndex: index] integerValue] == 1){
                [bcTableCell.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
            }else if([[bcCheckArray objectAtIndex: index] integerValue] == 0){
                [bcTableCell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
            }
        }

        
        
//        if (nowState == MemberEdit) {
//            for (int i = 0; i < bcArray.count; i++) {
//                if(index == i){
//                    if([[bcCheckArray objectAtIndex: i] integerValue] == 1){
//                        [bcTableCell.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
//                    }else if([[bcCheckArray objectAtIndex: i] integerValue] == 0){
//                        [bcTableCell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//                    }
//                }
//            }
//        }
                
//                if([[checkArray objectAtIndex: i] integerValue] == 1){
//                    [bcTableCell.cellBtn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
//                }else if([[checkArray objectAtIndex: i] integerValue] == 0){
//                    [bcTableCell.cellBtn setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//                    
//                }
//            }
//        }
    }else {
        bcTableCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
        if(bcTableCell == nil){
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BcTableCell" owner:nil options:nil];
            
            bcTableCell = [array objectAtIndex:0];
            bcTableCell.frame = CGRectMake(0, 0, 0, 0 );
            
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int index = [indexPath row];
        
    if (edit) {
        if (nowState == CardEdit) {
            
            BcTableCell *cell = (BcTableCell *)[businessCardTable cellForRowAtIndexPath:indexPath];

            
            if ([[bcCheckArray objectAtIndex: index] integerValue] == 0) {
                [bcCheckArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 1]];
                [cell.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                //                clickCount++;
            }else{
                [bcCheckArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 0]];
                [cell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
                //                clickCount--;
            }


//            if (clickCount > 0 && !cMenuOpen) {
//                [self cardMenu];
//                cMenuOpen = true;
//            }else if(clickCount <= 0 && cMenuOpen){
//                [cMenu01 removeFromSuperview];
//                cMenuOpen = false;
//            }
            
        }else if (nowState == MemberEdit){
            
            BcTableCell *cell = (BcTableCell *)[businessCardTable cellForRowAtIndexPath:indexPath];
            
            
            if ([[bcCheckArray objectAtIndex: index] integerValue] == 0) {
                [bcCheckArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 1]];
                [cell.checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                //                clickCount++;
            }else{
                [bcCheckArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 0]];
                [cell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
                //                clickCount--;
            }
//            if ([[checkArray objectAtIndex: index] integerValue] == 0) {
//                [checkArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 1]];
//            }else{
//                [checkArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: 0]];
//            }
        }
        
//        [businessCardTable reloadData];
    }else{
//        [self cardDetailView:[[bcArray objectAtIndex:index]integerValue]];
    }
    
}


// ---------------- Alert Event ---------------- //

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
            
            editBcViewController = [[EditBcViewController alloc]init];
            [editBcViewController setCardImg:[UIImage imageNamed:@"blue.png"]:@"이름":@"12345":@"email@email.com":0:0:0:0:0:0:0:0:0:0:0:0];
            
            [self.view insertSubview:editBcViewController.view aboveSubview:self.view];

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
