//
//  EditBcViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardOne.h"
#import "CardTwo.h"
#import "DataStruct.h"

@interface EditBcViewController : UIViewController{
    UILabel *nameLabel;
    UILabel *numberLabel;
    UILabel *emailLabel;
    
    CardOne *_cardOne;
    CardTwo *_cardTwo;
    
    UIView *loadCardView;
    
    DataStruct *dStruct;
}
- (IBAction)backBtn:(id)sender;
- (IBAction)okBtn:(id)sender;
- (void)setCardNum:(int)num;
- (void)setCardImg:(UIImage *)img:(NSString *)_name:(NSString *)_number:(NSString *)_email:
(float)_nameX:(float)_nameY:(float)_nameW:(float)_nameH:
(float)_numberX:(float)_numberY:(float)_numberW:(float)_numberH:
(float)_emailX:(float)_emailY:(float)_emailW:(float)_emailH;
@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property int nowCard;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@end
