//
//  DataBase.h
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
#import "DataStruct.h"

@interface DataBase : NSObject{
    sqlite3 *database;
    DataStruct *dStruct;
}

+ (DataBase*) getInstance;

-(NSMutableArray *)getGroupIds;
-(void)groupInsert:(NSString *)group_name;
-(NSString *)getGroupName:(int)_id;

-(NSMutableArray *)getBcIds;
-(int)bcInsert;
-(void)insertContents:(int)_id:(int)type:(NSString *)text:
(float)x:(float)y:(float)h:(float)w;
-(DataStruct *)getData:(int)_id;
@end
