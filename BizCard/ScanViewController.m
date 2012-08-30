//
//  ScanViewController.m
//  BizCard
//
//  Created by SeiJin on 12. 8. 26..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "ScanViewController.h"
#import "EditBcViewController.h"
#import "EvernoteSDK.h"
#import "NSData+MD5.h"
#import "PlistClass.h"

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
    [self createEvernoteNote];
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



//----------------------------------------------------------------
// 1. Evernote의 Note를 만든다.
//----------------------------------------------------------------
-(void)createEvernoteNote{
    
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    // note 구성하기  - Resource 설정
    NSData *imageData = UIImagePNGRepresentation(imageView.image);
    EDAMData *data = [[EDAMData alloc] initWithBodyHash:[imageData md5Hash] size:[imageData length] body:imageData];
    
    EDAMResource *resource = [[EDAMResource alloc] init];
    [resource setData:data];
    [resource setMime:@"image/png"];
    
    NSMutableArray *resources = [NSMutableArray array];
    [resources addObject:resource];
    
    // note 구성하기- Text 설정
    NSMutableString *saveContents = [NSMutableString string];
    [saveContents setString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [saveContents appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">"];
    [saveContents appendString:@"<en-note>"];
    [saveContents appendString:@"TEST IMAGE"];   //note 구성하기 - 본문 내용
    [saveContents appendFormat:@"<en-media type=\"image/png\" hash=\"%@\"/><br/>", [imageData md5HexHash]];
    [saveContents appendString:@"</en-note>"];
    
    
    // note 구성하기- 시간, 타이틀 등등 설정
    EDAMNote *note = [[EDAMNote alloc] init] ;
    NSString *notebook_guid = [PlistClass read_notebook_guid];
    
    [note setNotebookGuid:notebook_guid];
    [note setTitle:@"명함"];
    [note setActive:YES];
    [note setResources:resources];
    [note setContent:saveContents];
    [note setCreated:(long long)[[NSDate date] timeIntervalSince1970] * 1000];
    
    NSLog(@"start creating note");
    
    timeCheckforCreatingNote = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkTime) userInfo:nil repeats:YES];
    
    
    // 노트를 생성한다.
    [noteStore createNote:note success:^(EDAMNote *note) {
        
        NSLog(@"Created note: %@", [note title]);
        NSLog(@"Created note guid: %@", [note guid]);
        NSLog(@"Created note resource guid: %@", [[[note resources] objectAtIndex:0] guid]);
        
        [timer invalidate];
        timer = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkTime) userInfo:nil repeats:YES];
        
        // 4. 생성한 노트의 resource 아이디를 가지고 recgonition 정보를 불러온다
        NSLog(@"start checking if recognition has finished");
        NSLog(@"note guid %@", [note guid]);
        NSLog(@"resources count: %d", [[note resources] count]);
        
        NSString *resouce_guid = [[[note resources] objectAtIndex:0] guid];
        [self findRecognition:resouce_guid];
        
        
    } failure:^(NSError *error) {
        NSLog(@"failed to create note with error: %@",error);
        [timer invalidate];
        timer = 0;
    }];
}

//---------------------------------------------------------------
// 2. 이 Note의 Resource의 recognition 정보를 찾는다.
//---------------------------------------------------------------
-(void)findRecognition:(NSString *)Resource_guid{
    
    //NSLog(@"resource_guid %@", Resource_guid);
    
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [noteStore getResourceRecognitionWithGuid:Resource_guid success:^(NSData *data) {
        
        [self initVariables];
        
        // XML 파싱
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
        [xmlParser setDelegate:self];
        [xmlParser parse];
        
        NSLog(@"\n\n ***** Total Time SCANING the namecard = %d ***** \n\n", timeCheckforCreatingNote);
        [timer invalidate];
        timer = 0;
        
    } failure:^(NSError *error) {
        //NSLog(@"failed to check imageRecognition with error: %@",error);
        
        // 실패하면 다시 시도
        [self findRecognition:Resource_guid];
        
    }];
}

//---------------------------------------------------------------
// 3. 정보를 찾았으면 XML 파싱을 해서 데이터를 정리한다.
//---------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
    if([elementName isEqualToString:@"item"]){
        
        textContent = attributeDict;
        will_insert_data = YES;
    }    
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    // 병합될때
    // X: 맨 처음값
    // Y: 맨 처음값
    // W: 병합된 모든 값의 합
    // H: 맨 처음값
    
    if(will_insert_data){
        
        [textContent setValue:string forKey:@"text"];
        will_insert_data = NO;
        
        int currentxmlParsingX = [[textContent objectForKey:@"x"] intValue];
        int currentxmlParsingY = [[textContent objectForKey:@"y"] intValue];
        int currentxmlParsingW = [[textContent objectForKey:@"w"] intValue];
        int currentxmlParsingH = [[textContent objectForKey:@"h"] intValue];
        
        
        // 현재 x값 보다 기존 x값이 더 크거나 맨 처음 (-1)이거나
        // 현재, 기존 y값이 차가 15이상이면
        // (즉 새로운 Text라면) 현재까지 병합된 Text정보를 저장한다.
        if(currentxmlParsingX < previous_x
           || currentxmlParsingY - previous_y > 15
           || currentxmlParsingY - previous_y < -15
           || previous_x == -1)
        {
            
            /*
             if(currentxmlParsingY - previous_y >15 || currentxmlParsingY - previous_y < -15){
             SJ_DEBUG_LOG(@"-----Because of Y-----");
             }
             SJ_DEBUG_LOG(@"**********%@", xmlParsingText);
             SJ_DEBUG_LOG(@"%d", xmlParsingX);
             SJ_DEBUG_LOG(@"%d", xmlParsingY);
             SJ_DEBUG_LOG(@"%d", xmlParsingW);
             SJ_DEBUG_LOG(@"%d\n\n\n", xmlParsingH);
             */
            
            if( previous_x != -1){
                  
                // 찾은 문자열에서 이름, 번호, 이메일을 찾는다
                //-------------------------------------------------------------------------------------------------------
                // 1. Email 확인
                NSError *error   = nil;
                NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@".+@.+" options:0 error:&error];
                
                if (error != nil) {
                    NSLog(@"%@", error);
                }
                else {
                    
                    NSTextCheckingResult *match = [regexp firstMatchInString:xmlParsingText options:0 range:NSMakeRange(0, xmlParsingText.length)];
                    if(match.numberOfRanges!=0){
                        email = [xmlParsingText substringWithRange:[match rangeAtIndex:0]];
                        emailX = xmlParsingX;
                        emailY = xmlParsingY;
                        emailW = xmlParsingW;
                        emailH = xmlParsingH;
                    }
                }
                
                //-------------------------------------------------------------------------------------------------------
                // 2. 전화번호 확인
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
                NSString *filtered = [[xmlParsingText componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                if(filtered.length > 7 && filtered.length < 13 ){
                    phoneNumber = filtered;
                    phoneNumberX = xmlParsingX;
                    phoneNumberY = xmlParsingY;
                    phoneNumberW = xmlParsingW;
                    phoneNumberH = xmlParsingH;
                }
                
                //-------------------------------------------------------------------------------------------------------
                // 3. 이름 확인
                if(biggest_h < xmlParsingH){
                    name = xmlParsingText;
                    nameX = xmlParsingX;
                    nameY = xmlParsingY;
                    nameW = xmlParsingW;
                    nameH = xmlParsingH;
                }
            }
            
            xmlParsingText = [NSMutableString string];
            xmlParsingX = currentxmlParsingX;
            xmlParsingY = currentxmlParsingY;
            //xmlParsingH = currentxmlParsingH;
            xmlParsingH = -1;
        }
        
        [xmlParsingText appendString:[textContent objectForKey:@"text"]];
        previous_x=currentxmlParsingX;
        previous_y=currentxmlParsingY;
        //Merge Text 중 제일 큰 Height 및 총 width 구하기
        xmlParsingW += currentxmlParsingW;
        xmlParsingH = MAX(xmlParsingH, currentxmlParsingH);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
      
    /*
    NSString *message = [NSString stringWithFormat:@"Email: %@  \n PhoneNumber: %@ \n Name: %@",email, phoneNumber, name];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    */
    
    [self goEditBcView];
    
}
//---------------------------------------------------------------




-(void)checkTime{
    timeCheckforCreatingNote++;
    NSLog(@"%d",timeCheckforCreatingNote);
}


//---------------------------------------------------------------
//변수 초기화 (새로이 Recogintion 파싱할 때마다)
//---------------------------------------------------------------
- (void)initVariables{
    
    xmlParsingText = [NSMutableString string];
    xmlParsingX = -1;
    xmlParsingY = -1;
    xmlParsingW = -1;
    xmlParsingH = -1;
    previous_x = -1;
    previous_y = -1;
    biggest_h = -1;
}
//---------------------------------------------------------------





//-----------------------------------------------------------------------------------------------
// 스캔이 완료되면 EditView로 넘어가라
//-----------------------------------------------------------------------------------------------
-(void)goEditBcView{
    
    EditBcViewController *editBcViewCont = [EditBcViewController new];
    
    DataStruct *pushData = [[DataStruct alloc]init];
    
    NSLog(@"%@",name);
    NSLog(@"%f",nameX);
    NSLog(@"%f",nameY);
    NSLog(@"%f",nameW);
    NSLog(@"%f",nameH);

    NSLog(@"%@",phoneNumber);
    NSLog(@"%f",phoneNumberX);
    NSLog(@"%f",phoneNumberY);
    NSLog(@"%f",phoneNumberW);
    NSLog(@"%f",phoneNumberH);
    
    NSLog(@"%@",email);
    NSLog(@"%f",emailX);
    NSLog(@"%f",emailY);
    NSLog(@"%f",emailW);
    NSLog(@"%f",emailH);

    pushData.name = name;
    pushData.number = phoneNumber;
    pushData.email = email;
    pushData.nameX = nameX;
    pushData.nameY = nameY;
    pushData.nameW = nameW;
    pushData.nameH = nameH;
    pushData.emailX = emailX;
    pushData.emailY = emailY;
    pushData.emailW = emailW;
    pushData.emailH = emailH;
    pushData.numberX = phoneNumberX;
    pushData.numberY = phoneNumberY;
    pushData.numberW = phoneNumberW;
    pushData.numberH = phoneNumberH;
    
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
