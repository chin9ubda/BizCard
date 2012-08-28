//
//  OverlayView.m
//  BizCard
//
//  Created by SeiJin on 12. 8. 20..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        /*
        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //load an image to show in the overlay
        UIImage *crosshair = [UIImage imageNamed:@"test.png"];
        UIImageView *crosshairView = [[UIImageView alloc] initWithImage:crosshair];
        crosshairView.frame = CGRectMake(0, 40, 320, 300);
        crosshairView.contentMode = UIViewContentModeCenter;
        [self addSubview:crosshairView];
        
        //add a simple button to the overview
        //with no functionality at the moment
        UIButton *buttonRec = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [buttonRec setTitle:@"Take" forState:UIControlStateNormal];
        buttonRec.frame = CGRectMake(0, 430, 160, 40);
        
        [self addSubview:buttonRec];        
         */
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
