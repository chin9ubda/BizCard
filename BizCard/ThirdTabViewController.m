//
//  ThirdTabViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "ThirdTabViewController.h"

@interface ThirdTabViewController ()

@end

@implementation ThirdTabViewController

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


// --------------- Log Out Btn Event --------------- //

- (IBAction)logOutBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeTabbarController" object:nil];
}
@end
