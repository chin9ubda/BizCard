//
//  ScanViewController.h
//  BizCard
//
//  Created by SeiJin on 12. 8. 26..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

-(void)initView:(UIImage *)image;

@end
