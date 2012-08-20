//
//  SelectViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardOne.h"
#import "CardTwo.h"
#import "EditBcViewController.h"

@interface SelectViewController : UIViewController{
    EditBcViewController * editBcViewController;
    CardOne *_cardOne;
    CardTwo *_cardTwo;
}
- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bcTypeOne;
@property (strong, nonatomic) IBOutlet UIView *bcTypeTwo;

@end
