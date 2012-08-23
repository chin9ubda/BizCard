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

//    [self setCardTemplate];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillLayoutSubviews{
    [self setCardTemplate];
}


// ---------------- SetCardTemplate ---------------- //

-(void)setCardTemplate{
    
    
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"CardOne" owner:self options:nil];
    _cardOne = [xibs objectAtIndex:0];
 
    [self reSizeLabel:_cardOne.nameLabel:bcTypeOne.frame.size.width / _cardOne.frame.size.width];
    [self reSizeLabel:_cardOne.numberLabel:bcTypeOne.frame.size.width / _cardOne.frame.size.width];
    [self reSizeLabel:_cardOne.emailLabel:bcTypeOne.frame.size.width / _cardOne.frame.size.width];
    [self reSizeLabel:_cardOne.nameTitleLabel:bcTypeOne.frame.size.width / _cardOne.frame.size.width];
    [self reSizeLabel:_cardOne.numberTitleLabel:bcTypeOne.frame.size.width / _cardOne.frame.size.width];
    [self reSizeLabel:_cardOne.emailTitleLabel:bcTypeOne.frame.size.width / _cardOne.frame.size.width]; 
    
    _cardOne.frame = CGRectMake(0, 0, bcTypeOne.frame.size.width, _cardOne.frame.size.height);
    
    [bcTypeOne addSubview:_cardOne];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, bcTypeOne.frame.size.width, bcTypeOne.frame.size.height)];
    [btn setTag:1];
    [btn addTarget:self action:@selector(typeSetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bcTypeOne addSubview:btn];
    
    
    xibs = [[NSBundle mainBundle] loadNibNamed:@"CardTwo" owner:self options:nil];
    _cardTwo= (CardTwo *)[xibs objectAtIndex:0];
    [_cardTwo awakeFromNib];
        
    [self reSizeLabel:_cardTwo.nameLabel:bcTypeTwo.frame.size.width / _cardTwo.frame.size.width];
    [self reSizeLabel:_cardTwo.numberLabel:bcTypeTwo.frame.size.width / _cardTwo.frame.size.width];
    [self reSizeLabel:_cardTwo.emailLabel:bcTypeTwo.frame.size.width / _cardTwo.frame.size.width];
    [self reSizeLabel:_cardTwo.nameTitleLabel:bcTypeTwo.frame.size.width / _cardTwo.frame.size.width];
    [self reSizeLabel:_cardTwo.numberTitleLabel:bcTypeTwo.frame.size.width / _cardTwo.frame.size.width];
    [self reSizeLabel:_cardTwo.emailTitleLabel:bcTypeTwo.frame.size.width / _cardTwo.frame.size.width];
    
    _cardTwo.frame = CGRectMake(0, 0, bcTypeTwo.frame.size.width, _cardTwo.frame.size.height);
    
    [bcTypeTwo addSubview:_cardTwo];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, bcTypeTwo.frame.size.width, bcTypeTwo.frame.size.height)];
    [btn setTag:2];
    [btn addTarget:self action:@selector(typeSetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bcTypeTwo addSubview:btn];
    
    
}

// ---------------- Label Resize ---------------- //

-(void)reSizeLabel:(UILabel *)label:(float)resize{
    label.frame = CGRectMake(label.frame.origin.x * resize, label.frame.origin.y * resize, label.frame.size.width * resize, label.frame.size.height * resize);
    
    
    label.font = [UIFont systemFontOfSize:label.font.pointSize * resize];
    
    [label sizeToFit];
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
