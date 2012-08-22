//
//  ViewController.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarViewController.h"

@interface LoginViewController : UIViewController{
    TabbarViewController *tabbarController;
}
- (IBAction)loginBtn:(id)sender;

@end
