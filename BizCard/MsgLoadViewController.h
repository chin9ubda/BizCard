//
//  MsgLoadViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStruct.h"
#import "DataBase.h"
#import "MessageUI/MessageUI.h"

@interface MsgLoadViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>{
    NSArray *msgArray;
    NSArray *bcArray;
    int nowType;
    
    DataStruct *dStruct;
    DataBase *db;
}

- (IBAction)cancelBtn:(id)sender;
-(void)setArray:(NSArray *)arry;
-(void)setType:(int)type;
@end
