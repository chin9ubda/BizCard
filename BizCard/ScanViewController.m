//
//  ScanViewController.m
//  BizCard
//
//  Created by SeiJin on 12. 8. 26..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "ScanViewController.h"
#import "EditBcViewController.h"

#define IMAGEPICKER_CAMERA 0
#define IMAGEPICKER_PHOTO_ALBUM 1

@interface ScanViewController ()

@end

@implementation ScanViewController
@synthesize imageView;
@synthesize indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)closeView:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}



-(void)initView:(UIImage *)image type:(int)type{

    if(type == IMAGEPICKER_CAMERA){
        imageView.image = image;
        SJ_DEBUG_LOG(@"Camera SCAN");

        //Portrait Up 일때 가로가 더 크다
        NSLog(@"Original Image width = %f height= %f ",image.size.width, image.size.height);
        
        
        //세로면 이미지를 회전시킨다(무조건 가로가 되도록)
        UIImage *rotatedImage = [self scaleAndRotateImage:image];
        NSLog(@"Rotated Image width = %f height= %f ",rotatedImage.size.width, rotatedImage.size.height);
        
        
        // 이미지를 Crop한다.
        UIImage *croppedImage = [self cropImage:rotatedImage];
        NSLog(@"Cropped Image width = %f height= %f ",croppedImage.size.width, croppedImage.size.height);
        
        
        // 이미지의 크기를 줄인다. (Proportionally 하게 가로는 900에 맞추고)
        float resizeRatio_x = 900 / croppedImage.size.width ;
        UIImage *smallImage = [self imageWithImage:croppedImage scaledToSize:CGSizeMake(900, croppedImage.size.height*resizeRatio_x)];
        NSLog(@"Small Image width = %f height= %f ",smallImage.size.width, smallImage.size.height);
        
        imageView.image = smallImage;
        
    }else{
        imageView.image = image;
        SJ_DEBUG_LOG(@"Photo Album SCAN");
    }
    
    [indicator startAnimating];
}


//-----------------------------------------------------------------------------------------------
// 이미지 보정
//-----------------------------------------------------------------------------------------------
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    UIImage *newImage;
    
    SJ_DEBUG_LOG(@"Image Orientation : %d", image.imageOrientation);
    
    if(image.imageOrientation==UIImageOrientationLeft)
    {
        SJ_DEBUG_LOG(@"Landscape Left");
        //newImage = [image imageRotatedByDegrees:(M_PI/2)];
        newImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                              scale: 1.0
                                        orientation: UIImageOrientationUp];
        
    }
    else if(image.imageOrientation==UIImageOrientationRight)
    {
        SJ_DEBUG_LOG(@"Landscape Right");
        //newImage = [image imageRotatedByDegrees:(-M_PI/2)];
        newImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                              scale: 1.0
                                        orientation: UIImageOrientationUp];
        
    }
    else if(image.imageOrientation==UIImageOrientationUp)
    {
        //DO NOTHING (원본 이미지를 리턴)
        SJ_DEBUG_LOG(@"Portrait Up");
        return image;
    }
    else if(image.imageOrientation==UIImageOrientationDown)
    {
        SJ_DEBUG_LOG(@"Portrait Down");
        //newImage = [image imageRotatedByDegrees:(M_PI)];
        newImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                              scale: 1.0
                                        orientation: UIImageOrientationUp];
        
    }
    
    return newImage;
    
}

- (UIImage *)cropImage:(UIImage *)image{
    
    float ratio_x = image.size.width/425;
    float ratio_y = image.size.height/320;
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(ratio_x*12, ratio_y*48, ratio_x*405, ratio_y*225));
    UIImage *croppedImage =[UIImage imageWithCGImage:imageRef];
    return croppedImage;
    
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//-----------------------------------------------------------------------------------------------




//-----------------------------------------------------------------------------------------------
// 스캔이 완료되면 EditView로 넘어가라
//-----------------------------------------------------------------------------------------------
-(void)goEditBcView{
    
    EditBcViewController *editBcViewCont = [EditBcViewController new];
    
    DataStruct *pushData = [[DataStruct alloc]init];
    
    pushData.name = @"이름";
    pushData.number = @"123";
    pushData.email = @"123@123.com";
    
    [editBcViewCont setCardImg:0 :imageView.image :pushData];
    pushData = nil;
    
    
    //[self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:editBcViewCont animated:YES];
}
//-----------------------------------------------------------------------------------------------















- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
