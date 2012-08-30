//
//  EditBcViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "EditBcViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataBase.h"


#define Insert 0
#define Update 1

@interface EditBcViewController ()

@end

@implementation EditBcViewController
@synthesize nameTextField;
@synthesize numberTextField;
@synthesize emailTextField;
@synthesize mainScrollView;
@synthesize cardImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCardImage:nil];
    [self setNameTextField:nil];
    [self setNumberTextField:nil];
    [self setEmailTextField:nil];
    [self setMainScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}




// ---------------- 불러오기 , 촬영으로 적용시 or edit ---------------- //

- (void)viewWillLayoutSubviews{
    if (nowCard == 0) {
        nameTextField.text = dStruct.name;
        numberTextField.text = dStruct.number;
        emailTextField.text = dStruct.email;
        cardImage.image = cardImg;
    } else {
        [self setCardTemplate];
    }
}



// ---------------- SetCardImg ---------------- //

/* ------------------------------------------------
     이 함수에 사진찍은 이미지 & 데이터 전송
     이미지, 이름, 전화번호, 이메일, 이름X좌표, 이름Y좌표, 이름넓이, 
     이름높이,번호X좌표, 번호Y좌표, 번호넓이, 번호높이,이메일X좌표, 
     이메일Y좌표, 이메일넓이, 이메일높이

    toSJ
  ------------------------------------------------ */
 
- (void)setCardImg:(int)_id:(UIImage *)img:(DataStruct *)data{
    nowId = _id;
    dStruct = data;
    cardImg = img;
    
}

// -------- View Click Event -------- //

/* ----------------------------------
   TextField 외의 부분을 클릭하였을 경우 
   keybord Hide & ScrollView 위치 변경
  ----------------------------------- */

- (void)bgView:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}







// ---------------- SetCardView ---------------- //

-(void)setCardNum:(int)num{
    nowCard = num;
}



// ---------------- Select Template Set ---------------- //

- (void) setCardTemplate{
    NSArray *xibs;
    
    switch (nowCard) {
        case 1:
            xibs = [[NSBundle mainBundle] loadNibNamed:@"CardOne" owner:self options:nil];
            _cardOne = (CardOne *)[xibs objectAtIndex:0];
            [_cardOne awakeFromNib];
            loadCardView = [[UIView alloc]initWithFrame:CGRectMake(125, 13, 225, 125)];
            
            [self reSizeLabel:_cardOne.nameTitleLabel:loadCardView.frame.size.width / _cardOne.frame.size.width];
            [self reSizeLabel:_cardOne.numberTitleLabel:loadCardView.frame.size.width / _cardOne.frame.size.width];
            [self reSizeLabel:_cardOne.emailTitleLabel:loadCardView.frame.size.width / _cardOne.frame.size.width];
            [self reSizeLabel:_cardOne.nameLabel:loadCardView.frame.size.width / _cardOne.frame.size.width];
            [self reSizeLabel:_cardOne.numberLabel:loadCardView.frame.size.width / _cardOne.frame.size.width];
            [self reSizeLabel:_cardOne.emailLabel:loadCardView.frame.size.width / _cardOne.frame.size.width];
            
            _cardOne.frame = CGRectMake(0, 0, loadCardView.frame.size.width, loadCardView.frame.size.height);
            
            nameLabel = _cardOne.nameLabel;
            numberLabel = _cardOne.numberLabel;
            emailLabel = _cardOne.emailLabel;
            
            [loadCardView addSubview:_cardOne];
            [mainScrollView addSubview:loadCardView];
                        
            break;
        case 2:
            
            xibs = [[NSBundle mainBundle] loadNibNamed:@"CardTwo" owner:self options:nil];
            _cardTwo = (CardTwo *)[xibs objectAtIndex:0];
            [_cardTwo awakeFromNib];
            loadCardView = [[UIView alloc]initWithFrame:CGRectMake(129, 13, 225, 125)];
            
            [self reSizeLabel:_cardTwo.nameLabel:loadCardView.frame.size.width / _cardTwo.frame.size.width];
            [self reSizeLabel:_cardTwo.numberLabel:loadCardView.frame.size.width / _cardTwo.frame.size.width];
            [self reSizeLabel:_cardTwo.emailLabel:loadCardView.frame.size.width / _cardTwo.frame.size.width];
            [self reSizeLabel:_cardTwo.nameTitleLabel:loadCardView.frame.size.width / _cardTwo.frame.size.width];
            [self reSizeLabel:_cardTwo.numberTitleLabel:loadCardView.frame.size.width / _cardTwo.frame.size.width];
            [self reSizeLabel:_cardTwo.emailTitleLabel:loadCardView.frame.size.width / _cardTwo.frame.size.width];
            
            _cardTwo.frame = CGRectMake(0, 0, loadCardView.frame.size.width, loadCardView.frame.size.height);
            
            nameLabel = _cardTwo.nameLabel;
            numberLabel = _cardTwo.numberLabel;
            emailLabel = _cardTwo.emailLabel;
            
            [loadCardView addSubview:_cardTwo];
            [mainScrollView addSubview:loadCardView];

            
            break;
        default:
            break;
    }
}




// ---------------- Label Resize ---------------- //

-(void)reSizeLabel:(UILabel *)label:(float)resize{

    label.frame = CGRectMake(label.frame.origin.x * resize, label.frame.origin.y * resize, label.frame.size.width * resize, label.frame.size.height * resize);

    label.font = [UIFont systemFontOfSize:label.font.pointSize * resize];    
    
    [label sizeToFit];
    
}

// ---------------- Back Btn Event ---------------- //

- (IBAction)backBtn:(id)sender {
   
    if (nowCard == 0) {
        if (nowId == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
        }
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}


// ---------------- Ok Btn Event ---------------- //

- (IBAction)okBtn:(id)sender {
    DataBase *db = [DataBase getInstance];
    
    if (nowId != 0) {
        
        dStruct.name = nameTextField.text;
        dStruct.number = numberTextField.text;
        dStruct.email = emailTextField.text;
        
        [db bcUpdate:nowId :dStruct];
        [self dismissModalViewControllerAnimated:YES];
    }else {
        int _id = [db bcInsert];
        NSString *fileName = [NSString stringWithFormat:@"%d",_id];
        
        float tempSize = loadCardView.frame.size.width;
        
        loadCardView.frame = CGRectMake(0.0f, 0.0f, 450.0f, 250.0f);
        
        if (nowCard == 0) {
            cardImage.frame = CGRectMake(0.0f, 0.0f, 450.0f, 250.0f);
            
            dStruct.name = nameTextField.text;
            dStruct.number = numberTextField.text;
            dStruct.email = emailTextField.text;

            
            [db insertContents:_id :1 :dStruct.name :dStruct.nameX :dStruct.nameY :dStruct.nameH :dStruct.nameW];
            [db insertContents:_id :2 :dStruct.number :dStruct.numberX :dStruct.numberY :dStruct.numberH :dStruct.numberW];
            [db insertContents:_id :3 :dStruct.email :dStruct.emailX :dStruct.emailY :dStruct.emailH :dStruct.emailW];
            
            [self saveImg:fileName:[self captureView:cardImage]];
            
            [self dismissModalViewControllerAnimated:YES];
        }else{
            nameLabel.text = nameTextField.text;
            [nameLabel sizeToFit];
            numberLabel.text = numberTextField.text;
            [numberLabel sizeToFit];
            emailLabel.text = emailTextField.text;
            [emailLabel sizeToFit];
            
            [self reSizeLabel:_cardOne.nameTitleLabel:loadCardView.frame.size.width / tempSize];
            [self reSizeLabel:_cardOne.numberTitleLabel:loadCardView.frame.size.width / tempSize];
            [self reSizeLabel:_cardOne.emailTitleLabel:loadCardView.frame.size.width / tempSize];
            [self reSizeLabel:_cardOne.nameLabel:loadCardView.frame.size.width / tempSize];
            [self reSizeLabel:_cardOne.numberLabel:loadCardView.frame.size.width / tempSize];
            [self reSizeLabel:_cardOne.emailLabel:loadCardView.frame.size.width / tempSize];
            
            [db insertContents:_id :1 :nameLabel.text :nameLabel.frame.origin.x :nameLabel.frame.origin.y :nameLabel.frame.size.height :nameLabel.frame.size.width];
            [db insertContents:_id :2 :numberLabel.text :numberLabel.frame.origin.x :numberLabel.frame.origin.y :numberLabel.frame.size.height :numberLabel.frame.size.width];
            [db insertContents:_id :3 :emailLabel.text :emailLabel.frame.origin.x :emailLabel.frame.origin.y :emailLabel.frame.size.height :emailLabel.frame.size.width];
            [self saveImg:fileName:[self captureView:loadCardView]];
            
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"select_remove" object:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];
}




// ---------------- Capture Image ---------------- //


-(UIImage*)captureView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}



// ---------------- Save Image ---------------- //

-(void)saveImg:(NSString *)fileName:(UIImage *)image{
    NSString *file = [NSString stringWithFormat:@"Documents/%@.png",fileName];
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:file];
    
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
}




// ------------------------ TextField Setting ------------------------ //


// ------- TextField 'Retrun' Key Event ------- //

/* --------------------------------------------
   nameTextField return  - > numberTextField
   numberTextField return  - > emailTextField
   emailTextFiele return  - > Keyboard Hide
                              ScrollView Set
   -------------------------------------------- */

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:nameTextField]){
        [numberTextField becomeFirstResponder];
        
    }else if([textField isEqual:numberTextField]){
        [emailTextField becomeFirstResponder];
                
    }else{
        [textField resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect = self.view.frame;
        
        
        [mainScrollView setContentOffset:CGPointMake(0,0) animated:YES];
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    return true;
}



// --------- TextField BeginEditing --------- //

/* ------------------------------------------
   TextField Edit 실행시. 해당 TextField 값만큼 
   ScrollView 위치 조정
   ------------------------------------------ */

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    
    
    [mainScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
    self.view.frame = rect;
    [UIView commitAnimations];
    
    return YES;
}



// -------- TextField EndEditing -------- //

/* --------------------------------------
   TextField Edit 실행시. 각 Label 값 변경
   -------------------------------------- */


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (nowCard != 0) {
    
        if([textField isEqual:nameTextField]){
            nameLabel.text = nameTextField.text;
            [nameLabel sizeToFit];
            
        }else if([textField isEqual:numberTextField]){
            numberLabel.text = numberTextField.text;
            [numberLabel sizeToFit];
            
        }else{
            emailLabel.text = emailTextField.text;
            [emailLabel sizeToFit];
        }
    }

    return YES;
}

@end
