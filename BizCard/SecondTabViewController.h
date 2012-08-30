//
//  SecondTabViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "Msg_Cell.h"
#import "Add_MsgViewController.h"

@interface SecondTabViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    
    NSArray *msgArray;
    DataBase *db;
    Msg_Cell *msg_cell;
    Add_MsgViewController *addMsgBtn;
    
    int nowId;
}
@property (strong, nonatomic) IBOutlet UITableView *msgTable;
@end
