//
//  SelectBCTemplateViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 23..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardOne.h"
#import "CardTwo.h"
#import "EditBcViewController.h"

@interface SelectBCTemplateViewController : UIViewController{
    EditBcViewController * editBcViewController;
    CardOne *_cardOne;
    CardTwo *_cardTwo;
    NSString *_name;
    NSString *_number;
    NSString *_email;
}
- (IBAction)backBtn:(id)sender;
- (void)setData:(NSString *)name:(NSString *)number:(NSString *)email;
@property (strong, nonatomic) IBOutlet UIView *bcTypeOne;
@property (strong, nonatomic) IBOutlet UIView *bcTypeTwo;


@end
