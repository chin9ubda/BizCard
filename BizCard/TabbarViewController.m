//
//  TabbarViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "TabbarViewController.h"
#import "FirstTabViewController.h"
#import "SecondTabViewController.h"
#import "ThirdTabViewController.h"


@interface TabbarViewController ()

@end

@implementation TabbarViewController



// ---------------- Tabbar Init ---------------- //
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIViewController *firstTabController = [[FirstTabViewController alloc] initWithNibName:@"FirstTabViewController" bundle:nil];
        UIViewController *secondTabController = [[SecondTabViewController alloc] initWithNibName:@"SecondTabViewController" bundle:nil];
        UIViewController *thirdViewController = [[ThirdTabViewController alloc] initWithNibName:@"ThirdTabViewController" bundle:nil];
        
        self.viewControllers = @[firstTabController, secondTabController, thirdViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewSizeSet:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarHide) name:@"tabbarHide" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarOpen) name:@"tabbarOpen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarMake) name:@"tabbarMake" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarControllerRemove) name:@"removeTabbarController" object:nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


// ---------------- Add TabbarView ---------------- //
-(void)viewWillLayoutSubviews{
    
}


// ---------------- View Size Set ---------------- //
- (void) viewSizeSet:(UITabBarController *) tabbarcontroller {
    
    tabbarcontroller.view.frame = CGRectMake(0,0,480,300);
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
        
    }
}


// ---------------- First Tab ---------------- //
-(void)moveToFirstTab{
    self.selectedIndex = 0;
    [self tabbarUp];
}

// ---------------- Second Tab ---------------- //
-(void)moveToSecondTab{
    self.selectedIndex = 1;
    [self tabbarUp];
}

// ---------------- Thrid Tab ---------------- //
-(void)moveToThridTab{
    self.selectedIndex = 2;
    [self tabbarUp];
}

// ---------------- tabbarUp ---------------- //
-(void)tabbarUp{
    nowUpDown = false;
    [self moveView:tabbarView duration:0.1 curve:UIViewAnimationCurveLinear x:0 y:0];
    [tabbarView.tabbar_bg_img setImage:[UIImage imageNamed:@"main_tap_rotate_bg_120_380"]];
}


// ---------------- Tabbar Make ---------------- //
-(void)tabbarMake{
    
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"TabbarView" owner:self options:nil];
    tabbarView = (TabbarView *)[xibs objectAtIndex:0];
    
    tabbarView.frame = CGRectMake(250, 415, 190, 60);
    
    [tabbarView.bcTabBtn addTarget:self action:@selector(moveToFirstTab) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView.msgTabBtn addTarget:self action:@selector(moveToSecondTab) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView.settingTabBtn addTarget:self action:@selector(moveToThridTab) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView.menuBtn addTarget:self action:@selector(tabbarUpDown) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:tabbarView];
}

// ---------------- Tabbar Hide ---------------- //
-(void)tabbarHide{
    tabbarView.hidden=YES;
}


// ---------------- Tabbar Open ---------------- //
-(void)tabbarOpen{
    tabbarView.hidden=NO;
}

// ---------------- Tabbar Open ---------------- //
-(void)tabbarUpDown{
    if (nowUpDown) {
        [self tabbarUp];
    }else{
        nowUpDown = true;
        [self moveView:tabbarView duration:0.3 curve:UIViewAnimationCurveLinear x:-130 y:0];

        [tabbarView.tabbar_bg_img setImage:[UIImage imageNamed:@"main_tap1_rotate_120_380"]];
    }
}

// ---------------- Tabbar Controller Remove ---------------- //
-(void)tabbarControllerRemove{
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
    [self dismissModalViewControllerAnimated:YES];
}


// ---------------- MoveView ---------------- //
- (void)moveView:(UIView *)view duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    view.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
}


@end
