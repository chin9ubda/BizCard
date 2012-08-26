//
//  BCViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 23..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "BCViewController.h"
#import "EditBcViewController.h"

@interface BCViewController ()

@end

@implementation BCViewController
@synthesize bcImg;

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
    db = [DataBase getInstance];
    [self loadImg];
    dStruct =[db getData:getId];
    
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBcImg:nil];
    [super viewDidUnload];
    db = nil;
    dStruct = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)backBtn:(id)sender {
//    [self.view removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)editCard:(id)sender {
    EditBcViewController *editView = [[EditBcViewController alloc]init];
    
    [self presentModalViewController:editView animated:YES];
}


// ---------------- Image Load ---------------- //


-(void)loadImg{
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    
    reSize = bcImg.frame.size.width / img.size.width;
    
    bcImg.image = img;
    
    NSLog(@"%f",reSize);
    
}



// -------------------- Get Data from dStruct -------------------- //

/* ----------------------------------------------------------------
     이름, 전화번호, 이메일의 위치 및 크기를 받아와 화면에 표시 및 이벤트 설정 
   ----------------------------------------------------------------*/

-(void)getData{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(dStruct.nameX * reSize + bcImg.frame.origin.x, dStruct.nameY * reSize + bcImg.frame.origin.y, dStruct.nameW * reSize, dStruct.nameH * reSize)];
    [btn addTarget:self action:@selector(nameClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setAlpha:0.4f];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(dStruct.numberX*reSize+ bcImg.frame.origin.x, dStruct.numberY*reSize+ bcImg.frame.origin.y, dStruct.numberW*reSize, dStruct.numberH*reSize)];
    [btn2 addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    
    [btn2 setBackgroundColor:[UIColor blackColor]];
    [btn2 setAlpha:0.4f];
    [self.view addSubview:btn2];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setFrame:CGRectMake(dStruct.emailX*reSize+ bcImg.frame.origin.x, dStruct.emailY*reSize+ bcImg.frame.origin.y, dStruct.emailW*reSize, dStruct.emailH*reSize)];
    [btn3 addTarget:self action:@selector(emailClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [btn3 setBackgroundColor:[UIColor blackColor]];
    [btn3 setAlpha:0.4f];
    [self.view addSubview:btn3];
}



// -------------------- Calling -------------------- //

-(void)call{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",dStruct.number]]];
    
    NSLog(@"number    :     %@",dStruct.number);
    
}

// -------------------- Send Email -------------------- //

-(void)email{
    
    MFMailComposeViewController *mailsome=[[MFMailComposeViewController alloc] init];
    mailsome.mailComposeDelegate=self;
    if([MFMailComposeViewController canSendMail]){
        //        [mailsome setToRecipients:[NSArray arrayWithObjects:@"bbseejh@gmail.com", nil]];
        [mailsome setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",dStruct.email], nil]];
        [mailsome setSubject:nil];
        [mailsome setMessageBody:nil isHTML:NO];
        [self presentModalViewController:mailsome animated:YES];
    }
    
}

// -------------------- Imgae Set -------------------- //

-(void)setImg:(int)_id{
    
    fileName = [NSString stringWithFormat:@"%d.png",_id];
    getId = _id;
}


// -------------------- Name Click -------------------- //

-(void)nameClickEvent{
    NSLog(@"name : %@",dStruct.name);
}


// -------------------- Number Click -------------------- //

-(void)numberClickEvent{
    NSLog(@"number : %@",dStruct.number);
}



// -------------------- Email Click -------------------- //

-(void)emailClickEvent{
    NSLog(@"email : %@",dStruct.email);
}


@end
