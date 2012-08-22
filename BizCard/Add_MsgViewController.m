//
//  Add_MsgViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 22..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "Add_MsgViewController.h"

@interface Add_MsgViewController ()

@end

@implementation Add_MsgViewController
@synthesize delBtn, msg_TextView, msgScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [DataBase getInstance];
        nowType = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHide" object:nil];
    
    msg_TextView.text = setText;
    [msg_TextView becomeFirstResponder];
    
    if (nowType == 0) {
        delBtn.hidden = YES;
        
    }
    
}

- (void)viewDidUnload
{
    [self setMsg_TextView:nil];
    [self setDelBtn:nil];
    [self setMsgScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


-(void)setTextView:(NSString *)msg{
    setText = msg;
}

-(void)setType:(int)type{
    nowType = type;
}

- (IBAction)delMsg:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"확  인" message:@"정말 삭제하시겠습니까?" delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
}

- (IBAction)backBtn:(id)sender {
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    [self removeFromParentViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)okBtn:(id)sender {
    if ([msg_TextView.text isEqualToString:@""]) {
        NSLog(@"Not Msg");
    }else{
        if (nowType == 0)
            [db insertMsg:msg_TextView.text];
        else
            [db updateMsg:nowType :msg_TextView.text];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"msgTableReload" object:nil];
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        NSLog(@"OK");
        [db deleteMsg:nowType];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarOpen" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"msgTableReload" object:nil];
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

@end
