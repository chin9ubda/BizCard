//
//  ScanViewController.h
//  BizCard
//
//  Created by SeiJin on 12. 8. 26..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RECOINDEX,
    ITEM,
    T
}RECOGNITION_TYPE;


@interface ScanViewController : UIViewController <NSXMLParserDelegate> {
        
    NSTimer *timer;
    int timeCheckforCreatingNote;
    
    //XML 파싱 키워드들
    RECOGNITION_TYPE recognition_type;
    
    //XML Parsing element Name이 "item" 일 때만 의미 있는 정보이므로 이 때가 맞는지 확인
    BOOL will_insert_data;
    
    NSDictionary *textContent;
    
    // Recogintion 변수들
    NSMutableString *xmlParsingText;
    int xmlParsingX;
    int xmlParsingY;
    int xmlParsingW;
    int xmlParsingH;
    int previous_x;
    int previous_y;
    int biggest_h;
    
    
    NSString *name;
    NSString *phoneNumber;
    NSString *email;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

-(void)initView:(UIImage *)image type:(int)type;

@end
