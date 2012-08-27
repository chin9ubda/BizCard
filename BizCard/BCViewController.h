//
//  BCViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 23..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "DataStruct.h"
#import "MessageUI/MessageUI.h"

@interface BCViewController : UIViewController <MFMailComposeViewControllerDelegate ,MFMessageComposeViewControllerDelegate>{
    NSString *fileName;
    DataBase *db;
    DataStruct *dStruct;
    int getId;
    float reSize;
}
@property (strong, nonatomic) IBOutlet UIImageView *bcImg;
- (void)setImg:(int)_id;
- (IBAction)backBtn:(id)sender;
- (IBAction)editCard:(id)sender;

@end
