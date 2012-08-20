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

@interface EditBcViewController ()

@end

@implementation EditBcViewController
@synthesize nameTextField;
@synthesize numberTextField;
@synthesize emailTextField;
@synthesize cardImage, nowCard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dStruct = [DataStruct getInstance];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




// ---------------- 불러오기 , 촬영으로 적용시 or edit ---------------- //

-(void)viewWillLayoutSubviews{
    if (nowCard == 0) {
        nameTextField.text = dStruct.name;
        numberTextField.text = dStruct.number;
        emailTextField.text = dStruct.email;
    }
}



// ---------------- SetCardImg ---------------- //
// 이 함수에 사진찍은 이미지 & 데이터 전송

- (void)setCardImg:(UIImage *)img:(NSString *)_name:(NSString *)_number:(NSString *)_email:
(float)_nameX:(float)_nameY:(float)_nameW:(float)_nameH:
(float)_numberX:(float)_numberY:(float)_numberW:(float)_numberH:
(float)_emailX:(float)_emailY:(float)_emailW:(float)_emailH{
    
    cardImage.image = img;
    
    dStruct.name = _name;
    dStruct.number = _number;
    dStruct.email = _email;
    
    dStruct.nameX = _nameX;
    dStruct.nameY = _nameY;
    dStruct.nameH = _nameH;
    dStruct.nameW = _nameW;
    
    dStruct.numberX = _numberX;
    dStruct.numberY = _numberY;
    dStruct.numberH = _numberH;
    dStruct.numberW = _numberW;
    
    dStruct.emailX = _emailX;
    dStruct.emailY = _emailY;
    dStruct.emailH = _emailH;
    dStruct.emailW = _emailW;
}







// ---------------- SetCardView ---------------- //

-(void)setCardNum:(int)num{
    NSArray *xibs;
    nowCard = num;
    
    switch (num) {
        case 1:
            xibs = [[NSBundle mainBundle] loadNibNamed:@"CardOne" owner:self options:nil];
            _cardOne = (CardOne *)[xibs objectAtIndex:0];
            [_cardOne awakeFromNib];
            _cardOne.frame = CGRectMake(0, 0, 240, 120);
            nameLabel = _cardOne.nameLabel;
            numberLabel = _cardOne.numberLabel;
            emailLabel = _cardOne.emailLabel;
            loadCardView = [[UIView alloc]initWithFrame:CGRectMake(129, 57, 240, 120)];
            [loadCardView addSubview:_cardOne];
            [self.view addSubview:loadCardView];
            
            break;
        case 2:
            
            xibs = [[NSBundle mainBundle] loadNibNamed:@"CardTwo" owner:self options:nil];
            _cardTwo = (CardTwo *)[xibs objectAtIndex:0];
            [_cardTwo awakeFromNib];
            _cardTwo.frame = CGRectMake(0, 0, 240, 120);
            nameLabel = _cardTwo.nameLabel;
            numberLabel = _cardTwo.numberLabel;
            emailLabel = _cardTwo.emailLabel;
            loadCardView = [[UIView alloc]initWithFrame:CGRectMake(129, 57, 240, 120)];
            [loadCardView addSubview:_cardTwo];
            [self.view addSubview:loadCardView];
            
            break;
        default:
            break;
    }
}


// ---------------- Back Btn Event ---------------- //

- (IBAction)backBtn:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


// ---------------- Ok Btn Event ---------------- //

- (IBAction)okBtn:(id)sender {
    DataBase *db = [DataBase getInstance];
    int _id = [db bcInsert];
    NSString *fileName = [NSString stringWithFormat:@"%d",_id];
    
    if (nowCard == 0) {
        [db insertContents:_id :1 :dStruct.name :dStruct.nameX :dStruct.nameY :dStruct.nameH :dStruct.nameW];
        [db insertContents:_id :2 :dStruct.number :dStruct.numberX :dStruct.numberY :dStruct.numberH :dStruct.numberW];
        [db insertContents:_id :3 :dStruct.email :dStruct.emailX :dStruct.emailY :dStruct.emailH :dStruct.emailW];
    }else{
        [db insertContents:_id :1 :nameLabel.text :nameLabel.frame.origin.x :nameLabel.frame.origin.y :nameLabel.frame.size.height :nameLabel.frame.size.width];
        [db insertContents:_id :2 :numberLabel.text :numberLabel.frame.origin.x :numberLabel.frame.origin.y :numberLabel.frame.size.height :numberLabel.frame.size.width];
        [db insertContents:_id :3 :emailLabel.text :emailLabel.frame.origin.x :emailLabel.frame.origin.y :emailLabel.frame.size.height :emailLabel.frame.size.width];
    }
    
    [self saveImg:fileName:[self captureView:loadCardView]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"select_remove" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}




// ---------------- Capture Image ---------------- //


-(UIImage*)captureView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    //    UI
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
@end
