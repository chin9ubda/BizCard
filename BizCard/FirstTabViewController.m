//
//  FirstTabViewController.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "FirstTabViewController.h"

#define CardEdit 1
#define MemberEdit 2

#define GroupAddTag 11
#define GroupEditTag 12
#define GroupDelTag 13
#define GroupSms 14
#define GroupEmail 15

#define CardAddTag 21
#define CardDelTag 23
#define CardSms 24
#define CardEmail 25

@interface FirstTabViewController ()

@end

@implementation FirstTabViewController

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



// ---------------- bcAddBtn Event ---------------- //
// --------------- show ActionSheet --------------- //
- (IBAction)bcAddBtn:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"취소"
                                  destructiveButtonTitle:@"사진 촬영"
                                  otherButtonTitles:@"앨범에서 가져오기", @"주소록에서 가져오기", @"직접 입력하기", nil];
    actionsheet.tag = CardAddTag;
    [actionsheet showInView:self.view];

}

// ---------------- actionSheet Event ---------------- //
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == CardAddTag) {
        NSLog(@"사진 찍기");
    }else if(buttonIndex == 1){
        NSLog(@"앨범에서 불러오기");
    }else if(buttonIndex == 2){
        NSLog(@"주소록에서 가져오기");
    }else if(buttonIndex == 3){
        NSLog(@"직접 입력하기");
    }
    
}
@end
