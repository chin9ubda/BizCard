//
//  PlistClass.m
//  BizCard
//
//  Created by SeiJin on 12. 8. 17..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "PlistClass.h"

@implementation PlistClass

+(void) DocumentFileCopy{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPlistPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"userData.plist"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:myPlistPath])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"userData" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:myPlistPath error:&error];
        SJ_DEBUG_LOG(@"파일복사됨");
    }else{
        SJ_DEBUG_LOG(@"파일이있음");
    }
}


//---------------------------------------------------------------------------
//  BizCard용 notebook Guid 읽고 쓰기
//---------------------------------------------------------------------------
+(void) write_notebook_guid:(NSString *)NotebookGuid{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPlistPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",@"userData"]];
    
    NSMutableDictionary *data  = [[NSMutableDictionary alloc]initWithContentsOfFile:myPlistPath];
    [data setObject:NotebookGuid forKey:@"NotebookGuid"];
    [data writeToFile:myPlistPath atomically:YES];
    
    SJ_DEBUG_LOG(@"NotebookGuid:%@", NotebookGuid);
}

+(NSString *) read_notebook_guid{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPlistPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",@"userData"]];
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:myPlistPath];
    NSString *NotebookGuid = [savedStock valueForKey:@"NotebookGuid"];
    
    SJ_DEBUG_LOG(@"NotebookGuid:%@", NotebookGuid);
    return NotebookGuid;
}
//---------------------------------------------------------------------------

@end
