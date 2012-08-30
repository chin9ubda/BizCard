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
#import "SelectBCTemplateViewController.h"
#import "EditBcViewController.h"
#import "Group_Menu.h"
#import "Card_Menu.h"
#import "BCViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

typedef enum {
    IMAGEPICKER_CAMERA,
    IMAGEPICKER_PHOTO_ALBUM,
    VIEW
}DISMISS_TYPE;


@interface FirstTabViewController : UIViewController
<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate,UITextFieldDelegate,
ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate>{
    DataBase *db;
    DataStruct *dStruct;
    
    NSMutableArray *groupArray;
    NSMutableArray *bcArray;
    NSMutableArray *bcCheckArray;
    NSMutableArray *groupBtnArray;
    
    SelectBCTemplateViewController *selectView;
    EditBcViewController *editBcViewController;
    BCViewController *bcView;
    
    int nowGroup;
    int nowState;
    Boolean search;
    int clickCount;
    int sortType;
    Boolean edit;
    
    Group_Menu *gMenu;
    Card_Menu *cMenu;
    
    // For Camera, Photo Album
    UIImagePickerController *imagepickerController;
    UIImage *scanImage;
    DISMISS_TYPE dismiss_type;

    
}
- (IBAction)addBCBtn:(id)sender;
- (IBAction)allGroupBtn:(id)sender;
- (IBAction)addGroupBtn:(id)sender;
- (IBAction)editBCBtn:(id)sender;
- (IBAction)sortBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *allGroupBtn;
@property (strong, nonatomic) IBOutlet UIButton *addGroupBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *groupScrollView;
@property (strong, nonatomic) IBOutlet UITableView *businessCardTable;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UIButton *tookPicture;
@end
