//
//  DataBase.m
//  BizCard
//
//  Created by 박 찬기 on 12. 8. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "DataBase.h"


#define DataBase_Name @"Biz.sqlite"
#define GroupTable_Name @"GroupTable"
#define BusinessCardTable_Name @"BusinessCard"
#define ContentsTable_Name @"Contents"
#define GroupMemberTable_Name @"GroupMember"
#define MsgTable_Name @"Msg"


@implementation DataBase

- (id)init
{
    self = [super init];
    if (self) {
        [self createOrOpenDB];
        [self createTable];
        dStruct = [DataStruct getInstance];
    }
    return self;
}


// ---------------- alloc return ---------------- //

+ (DataBase*) getInstance {
    static DataBase* _db = nil;
    
    if (_db == nil) {
        _db = [[DataBase alloc] init];
    }
    
    return _db;
}



// ---------------- DataBase Create or Open ---------------- //

-(void)createOrOpenDB{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DataBase_Name];
    
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        
        NSLog(@"Error");
    }else{
        NSLog(@"Create / Open DataBase");
    }
}

// ---------------- Table Create ---------------- //

-(void)createTable{
    
    NSString *query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id INTEGER PRIMARY KEY, name VARCHAR)",GroupTable_Name];
    
    const char *sql = [query UTF8String];
    
    if (sqlite3_exec(database, sql, nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error Group Table");
        NSLog(@"Table Name : %@",GroupTable_Name);
        
    }else{
        NSLog(@"Create Group Table");
    }
    
    query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id INTEGER PRIMARY KEY, noteGuid VARCHAR, insertDate TIMESTAMP, visitCount INTEGER, imgPath VARCHAR)",BusinessCardTable_Name];
    
    sql = [query UTF8String];
    
    if (sqlite3_exec(database, sql, nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error BC Table");
    }else{
        NSLog(@"Create BC Table");
    }
    query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id INTEGER PRIMARY KEY, bcid INTEGER, contentsType INTEGER, contentsText TEXT, contentsX FLOAT, contentsY FLOAT, contentsH FLOAT, contentsW FLOAT)",ContentsTable_Name];
    
    sql = [query UTF8String];
    
    if (sqlite3_exec(database, sql, nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error Contents Table");
    }else{
        NSLog(@"Create Contents Table");
    }
    
    query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id INTEGER PRIMARY KEY, groupNumber INTEGER, businessCardNumber INTEGER)",GroupMemberTable_Name];
    
    sql = [query UTF8String];
    
    if (sqlite3_exec(database, sql, nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error GroupMember Table");
    }else{
        NSLog(@"Create GroupMember Table");
    }
    
    
    
    query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id INTEGER PRIMARY KEY, msg TEXT)",MsgTable_Name];
    
    sql = [query UTF8String];
    
    if (sqlite3_exec(database, sql, nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Msg");
    }else{
        NSLog(@"Create Msg Table");
    }
    
}





// ------------------------------------------------ Group Table------------------------------------------------ //




// ---------------- Group Insert---------------- //

-(void)groupInsert:(NSString *)group_name{
    sqlite3_stmt *insertStatement;
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (name) VALUES('%@')",GroupTable_Name,group_name];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, [group_name UTF8String],  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }
    }
    
    
    sqlite3_finalize(insertStatement);
}


// ---------------- group Id Return ---------------- //

-(NSMutableArray *)getGroupIds{
    
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT _id FROM %@",GroupTable_Name];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    
    
    return array;
}


// ---------------- Group Name Return ---------------- //

-(NSString *)getGroupName:(int)_id{
    
    NSString *data;
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT name FROM %@ WHERE _id = %d",GroupTable_Name,_id];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            
            data = [NSString stringWithFormat:@"%@", name];
            
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return data;
    
}



// ---------------- Group Name Update ---------------- //

-(void)groupUpdate:(int)_id:(NSString *)name{
    sqlite3_stmt *updateStatement;
    NSString *query = [NSString stringWithFormat:@"REPLACE INTO %@ (_id,name) VALUES(?,?)",GroupTable_Name];
    
    const char *updateSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, updateSql, -1, &updateStatement, NULL) == SQLITE_OK) {
        
        //?에 데이터를 바인드
        sqlite3_bind_int(updateStatement, 1, _id);
        sqlite3_bind_text(updateStatement, 2, [name UTF8String],  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(updateStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }
    }
    
    
    sqlite3_finalize(updateStatement);
}



// ---------------- Group Delete ---------------- //

-(void)groupDel:(int)_id{
    
    //    sqlite3_stmt *delStatement;
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE _id = %d",GroupTable_Name,_id];
    
    const char *delSql = [query UTF8String];
    
    
    if (sqlite3_exec(database, delSql, nil,nil,nil) != SQLITE_OK) {
        
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
    
}



// ------------------------------------------------ BusinessCard Table------------------------------------------------ //





// ---------------- BusinessCard Insert---------------- //

-(void)bcInsert:(NSString *)bc_name{
    sqlite3_stmt *insertStatement;
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (name) VALUES('%@')",BusinessCardTable_Name,bc_name];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, [bc_name UTF8String],  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }
    }
    
    
    sqlite3_finalize(insertStatement);
}


// ---------------- BusinessCard Id Return ---------------- //

-(NSMutableArray *)getBcIds{
    
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT _id FROM %@",BusinessCardTable_Name];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    
    
    return array;
}


// ---------------- BusinessCard Data Return ---------------- //

-(DataStruct *)getData:(int)_id{
    
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT contentsText, contentsX, contentsY, contentsH, contentsW FROM %@ WHERE bcid = %d and contentsType = 1",ContentsTable_Name,_id];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            dStruct.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            dStruct.nameX = sqlite3_column_double(selectStatement, 1);
            dStruct.nameY = sqlite3_column_double(selectStatement, 2);
            dStruct.nameH = sqlite3_column_double(selectStatement, 3);
            dStruct.nameW = sqlite3_column_double(selectStatement, 4);
            
        }
    }
    query = [NSString stringWithFormat:@"SELECT contentsText, contentsX, contentsY, contentsH, contentsW FROM %@ WHERE bcid = %d and contentsType = 2",ContentsTable_Name,_id];
    
    selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            dStruct.number = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            dStruct.numberX = sqlite3_column_double(selectStatement, 1);
            dStruct.numberY = sqlite3_column_double(selectStatement, 2);
            dStruct.numberH = sqlite3_column_double(selectStatement, 3);
            dStruct.numberW = sqlite3_column_double(selectStatement, 4);
            
        }
    }
    query = [NSString stringWithFormat:@"SELECT contentsText, contentsX, contentsY, contentsH, contentsW FROM %@ WHERE bcid = %d and contentsType = 3",ContentsTable_Name,_id];
    
    selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            dStruct.email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            dStruct.emailX = sqlite3_column_double(selectStatement, 1);
            dStruct.emailY = sqlite3_column_double(selectStatement, 2);
            dStruct.emailH = sqlite3_column_double(selectStatement, 3);
            dStruct.emailW = sqlite3_column_double(selectStatement, 4);
        }
    }
    
    //statement close
    sqlite3_finalize(selectStatement);
    
    return dStruct;
}



// ---------------- BusinessCard Insert And _id Return ---------------- //

-(int)bcInsert{
    int cardId;
    
    sqlite3_stmt *insertStatement;
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (noteGuid, visitCount) VALUES('2',0)",BusinessCardTable_Name];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, insertSql,  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }else {
            sqlite3_stmt *selectStatement;
            NSString *query = [NSString stringWithFormat:@"SELECT _id FROM %@ ORDER BY _id DESC LIMIT 1",BusinessCardTable_Name];
            
            const char *selectSql = [query UTF8String];
            
            if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
                
                // while문을 돌면서 각 레코드의 데이터를 받아서 출력한다.
                while (sqlite3_step(selectStatement) == SQLITE_ROW) {
                    cardId = sqlite3_column_int(selectStatement, 0);
                }
                
            }
            
            //statement close
            sqlite3_finalize(selectStatement);
        }
    }
    
    sqlite3_finalize(insertStatement);
    
    
    query = [NSString stringWithFormat:@"UPDATE %@ SET imgPath = DATETIME('%d')  WHERE _id = %d",BusinessCardTable_Name,cardId,cardId];
    
    const char *updateSql = [query UTF8String];
    
    
    if (sqlite3_exec(database, updateSql, nil,nil,nil) != SQLITE_OK) {
        
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
    
    return cardId;
}




// ---------------- ContentsTable Insert And _id Return ---------------- //

-(void)insertContents:(int)_id:(int)type:(NSString *)text:(float)x:(float)y:(float)h:(float)w{
    
    sqlite3_stmt *insertStatement;
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (bcid, contentsType, contentsText, contentsX, contentsY, contentsH, contentsW) VALUES(%d,%d,'%@',%f,%f,%f,%f)",ContentsTable_Name, _id, type, text, x, y, h, w];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, insertSql,  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }
    }
    
    sqlite3_finalize(insertStatement);
}



// ---------------- Member Delete ---------------- //

-(void)memberDel:(int)gruop_id{
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE groupNumber = %d",GroupMemberTable_Name,gruop_id];
    
    const char *delSql = [query UTF8String];
    
    
    if (sqlite3_exec(database, delSql, nil,nil,nil) != SQLITE_OK) {
        
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
}


// ---------------- Member Update ---------------- //

-(void)memberUpdate:(int)group_Number:(int)card_Number{
    
    sqlite3_stmt *insertStatement;
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (groupNumber,businessCardNumber) VALUES(?,?)",GroupMemberTable_Name];
    
    NSLog(@"gID = %d , cId = %d",group_Number, card_Number);
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        //?에 데이터를 바인드
        sqlite3_bind_int(insertStatement, 1, group_Number);
        sqlite3_bind_int(insertStatement, 2, card_Number);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }
    }
    
    
    sqlite3_finalize(insertStatement);
}



// ---------------- Member Id Return ---------------- //

-(NSMutableArray *)getMemberIds:(int)group_id{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT businessCardNumber FROM %@ WHERE groupNumber = %d",GroupMemberTable_Name, group_id];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        // while문을 돌면서 각 레코드의 데이터를 받아서 출력한다.
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
        }
        
    }
    
    //statement close
    sqlite3_finalize(selectStatement);
    
    return array;
}


// ---------------- Msg Id Return ---------------- //

-(NSArray *)getMsgIds{
    NSString *data;
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT _id FROM %@",MsgTable_Name];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        // while문을 돌면서 각 레코드의 데이터를 받아서 출력한다.
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            int _id = sqlite3_column_int(selectStatement, 0);
            
            if (count == 0) {
                data = [NSString stringWithFormat:@"%d", _id];
            }else{
                data = [NSString stringWithFormat:@"%@|,|%d",data, _id];
            }
            count++;
        }
        
    }
    
    //statement close
    sqlite3_finalize(selectStatement);
    
    
    NSArray *array =[data componentsSeparatedByString:@"|,|"];
    
    return array;
}


// ---------------- Msg Return ---------------- //

-(NSString *)getMsg:(int)_id{
    NSString *data;
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT msg FROM %@ WHERE _id = %d",MsgTable_Name,_id];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            NSString *msg = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            
            data = [NSString stringWithFormat:@"%@", msg];
            
        }
    }
    
    //statement close
    sqlite3_finalize(selectStatement);
    
    return data;
    
}


// ---------------- Msg Insert ---------------- //


-(void)insertMsg:(NSString *)msg{
    
    sqlite3_stmt *insertStatement;
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (msg) VALUES('%@')",MsgTable_Name,msg];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, insertSql,  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }
    }
    
    sqlite3_finalize(insertStatement);
    
}


// ---------------- Msg Update ---------------- //

-(void)updateMsg:(int)_id:(NSString *)msg{
    
    NSLog(@"id ===  %d,  msg === %@",_id, msg);
    
    sqlite3_stmt *insertStatement;
    NSString *query = [NSString stringWithFormat:@"REPLACE INTO %@ (_id,msg) VALUES(?,?)",MsgTable_Name];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        //?에 데이터를 바인드
        sqlite3_bind_int(insertStatement, 1, _id);
        sqlite3_bind_text(insertStatement, 2, [msg UTF8String],  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }
    }
    
    
    sqlite3_finalize(insertStatement);
}


// ---------------- Msg Delete ---------------- //

-(void)deleteMsg:(int)_id{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE _id = %d",MsgTable_Name,_id];
    
    const char *delSql = [query UTF8String];
    
    
    if (sqlite3_exec(database, delSql, nil,nil,nil) != SQLITE_OK) {
        
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
}

@end
