//
//  DataStruct.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "DataStruct.h"

@implementation DataStruct

+(DataStruct *)getInstance{
    static DataStruct *dataStruct;
    
    if (dataStruct == nil) {
        dataStruct = [[DataStruct alloc]init];
    }
    
    return dataStruct;
}

@end
