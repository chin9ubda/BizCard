//
//  SelectViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController
@synthesize bcTypeOne, bcTypeTwo;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtn:) name:@"select_remove" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];

    [self setCardTemplate];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCardTemplate];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// ---------------- SetCardTemplate ---------------- //

-(void)setCardTemplate{
    
    
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"CardOne" owner:self options:nil];
    _cardOne = (CardOne *)[xibs objectAtIndex:0];
    
    [_cardOne setFrame:CGRectMake(0, 0, bcTypeOne.frame.size.width, bcTypeOne.frame.size.height)];
    
    [bcTypeOne addSubview:_cardOne];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, bcTypeOne.frame.size.width, bcTypeOne.frame.size.height)];
    [btn setTag:1];
    [btn addTarget:self action:@selector(typeSetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bcTypeOne addSubview:btn];
    
    
    xibs = [[NSBundle mainBundle] loadNibNamed:@"CardTwo" owner:self options:nil];
    _cardTwo= (CardTwo *)[xibs objectAtIndex:0];
    [_cardTwo awakeFromNib];
    _cardTwo.frame = CGRectMake(0, 0, bcTypeTwo.frame.size.width, bcTypeTwo.frame.size.height);
    
    [bcTypeTwo addSubview:_cardTwo];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, bcTypeTwo.frame.size.width, bcTypeTwo.frame.size.height)];
    [btn setTag:2];
    [btn addTarget:self action:@selector(typeSetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bcTypeTwo addSubview:btn];
    
    
}



// ---------------- Back Btn Event ---------------- //

- (IBAction)backBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}



// ---------------- Edit BC Btn Event ---------------- //

- (IBAction)typeSetBtn:(UIButton *)btn{
    editBcViewController = [[EditBcViewController alloc]init];
    [editBcViewController setCardNum:btn.tag];
    [self.view insertSubview:editBcViewController.view aboveSubview:self.view];
}
@end
