//
//  ScanViewController.m
//  BizCard
//
//  Created by SeiJin on 12. 8. 26..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController
@synthesize imageView;
@synthesize indicator;

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
    // Do any additional setup after loading the view from its nib.
}



-(void)initView:(UIImage *)image{

    imageView.image = image;
    [indicator startAnimating];
    SJ_DEBUG_LOG(@"SCAN SCAN");
}


- (IBAction)closeView:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}










- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
