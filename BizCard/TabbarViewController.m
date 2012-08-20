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
    
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"TabbarView" owner:self options:nil];
    tabbarView = (TabbarView *)[xibs objectAtIndex:0];
        
    tabbarView.frame = CGRectMake(0, 440, 300, 40);
    
    [tabbarView.bcTabBtn addTarget:self action:@selector(moveToFirstTab) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView.msgTabBtn addTarget:self action:@selector(moveToSecondTab) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView.settingTabBtn addTarget:self action:@selector(moveToThridTab) forControlEvents:UIControlEventTouchUpInside];

    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:tabbarView];
    
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
}

// ---------------- Second Tab ---------------- //
-(void)moveToSecondTab{
    self.selectedIndex = 1;
}

// ---------------- Thrid Tab ---------------- //
-(void)moveToThridTab{
    self.selectedIndex = 2;
}


// ---------------- Tabbar Hide ---------------- //
-(void)tabbarHide{
    tabbarView.hidden=YES;
}


// ---------------- Tabbar View ---------------- //
-(void)tabbarOpen{
    tabbarView.hidden=NO;
}

@end
