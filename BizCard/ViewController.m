//
//  ViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

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
    tabbarController = [[TabbarViewController alloc]init];
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




// ---------------- LoginBtn Event ---------------- //

- (IBAction)loginBtn:(id)sender {
    
    if ([self loginCheck]) {
        [self.view insertSubview:tabbarController.view aboveSubview:self.view];
    }else {
        NSLog(@"로그인 실패");
    }
}



// ---------------- LoginCheck ---------------- //
// ------------- 로그인 성공 : true ------------- //
// ------------- 로그인 실패 : false ------------ //

- (Boolean)loginCheck{
    
    return true;
}
@end
