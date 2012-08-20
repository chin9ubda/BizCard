//
//  FirstTabViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "DataStruct.h"
#import "SelectViewController.h"
#import "EditBcViewController.h"

@interface FirstTabViewController : UIViewController
<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    DataBase *db;
    DataStruct *dStruct;
    NSMutableArray *groupArray;
    NSMutableArray *bcArray;
    SelectViewController *selectView;
    EditBcViewController *editBcViewController;
    
    int nowGroup;
}
- (IBAction)bcAddBtn:(id)sender;
- (IBAction)allGroupBtn:(id)sender;
- (IBAction)addGroupBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *allGroupBtn;
@property (strong, nonatomic) IBOutlet UIButton *addGroupBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *groupScrollView;
@property (strong, nonatomic) IBOutlet UITableView *businessCardTable;

@end
