//
//  Add_MsgViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 22..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"

@interface Add_MsgViewController : UIViewController<UITextViewDelegate>{
    NSString *setText;
    Boolean keyboardVisible;

    DataBase *db;
    
    int nowType;

}

- (IBAction)backBtn:(id)sender;
- (IBAction)okBtn:(id)sender;
- (void)setTextView:(NSString *)msg;

- (void)setType:(int)type;
- (IBAction)delMsg:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *delBtn;
@property (strong, nonatomic) IBOutlet UITextView *msg_TextView;
@property (strong, nonatomic) IBOutlet UIScrollView *msgScrollView;

@end
