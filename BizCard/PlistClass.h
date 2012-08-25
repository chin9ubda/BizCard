//
//  PlistClass.h
//  BizCard
//
//  Created by SeiJin on 12. 8. 17..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistClass : NSObject

//Plist
+(void) DocumentFileCopy;
+(void) write_notebook_guid:(NSString *)NotebookGuid;
+(NSString *) read_notebook_guid;

@end
