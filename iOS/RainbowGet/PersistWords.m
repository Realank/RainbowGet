//
//  PersistWords.m
//  RainbowGet
//
//  Created by Realank on 2017/3/16.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "PersistWords.h"
#import <sqlite3.h>
@implementation PersistWords

+ (NSString*)oldDBPath{
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* filePath = [dirPath stringByAppendingPathComponent:@"newwords.db"];
    return filePath;
}

+ (NSString*)dbPath{
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* filePath = [dirPath stringByAppendingPathComponent:@"newwords2.db"];
    return filePath;
}

+ (BOOL)dbFileExist{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:[self dbPath] isDirectory:nil];
    
    if (existed) {
        return YES;
    }
    
    //不存在则创建
    char sql_stmt[1000];
    sqlite3 *newWordsDB; //Declare a pointer to sqlite database structure
    const char *dbpath = [[self dbPath] UTF8String]; // Convert NSString to UTF-8
    //打开数据库文件，没有则创建
    if (sqlite3_open(dbpath, &newWordsDB) == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
    //创建表
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char),"CREATE TABLE IF NOT EXISTS NEWWORDS (ID INTEGER PRIMARY KEY AUTOINCREMENT, JAPANESE TEXT, KANA TEXT, CHINESE TEXT, TYPE1 TEXT, TYPE2 TEXT, TYPE3 TEXT, TONE1 INTEGER, TONE2 INTEGER,  TONE3 INTEGER, ISHIRAGANA INTEGER, CLASSNAME TEXT, WORDID TEXT, AUDIOFILE TEXT, STARTTIME REAL, PERIODTIME REAL)");
    if (sqlite3_exec(newWordsDB, sql_stmt, NULL, NULL, NULL) == SQLITE_OK)
    {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败");
        return NO;
    }
    
    sqlite3_close(newWordsDB);//关闭数据库
    
    BOOL oldDBExisted = [fileManager fileExistsAtPath:[self oldDBPath] isDirectory:nil];
    if (oldDBExisted) {
        NSLog(@"迁移数据库");
        NSArray* wordsInOldDB = [self allWordsFromOldDB];
        [fileManager removeItemAtPath:[self oldDBPath] error:nil];
        for (WordModel* word in wordsInOldDB) {
            [self addWord:word];
        }
    }
    
    return YES;
}

+(NSArray<WordModel*>*)allWordsFromOldDB{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:[self oldDBPath] isDirectory:nil];
    if (!existed) {
        return nil;
    }
    
    char sql_stmt[1000];
    
    sqlite3 *newWordsDB; //Declare a pointer to sqlite database structure
    const char *dbpath = [[self oldDBPath] UTF8String]; // Convert NSString to UTF-8
    //打开数据库文件，没有则创建
    if (sqlite3_open(dbpath, &newWordsDB) == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
    sqlite3_stmt *statement;
    //－－－查－－－
    NSString* command = [NSString stringWithFormat:@"SELECT JAPANESE, KANA, CHINESE, TYPE1, TYPE2, TONE1, TONE2, ISHIRAGANA FROM NEWWORDS"];
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "%s", [command UTF8String]);
    //准备一个SQL语句，用于执行
    sqlite3_prepare_v2(newWordsDB, sql_stmt, -1, &statement, NULL);
    NSMutableArray* wordsList = [NSMutableArray array];
    //执行一条准备的语句,如果找到一行匹配的数据，则返回SQLITE_ROW
    while (sqlite3_step(statement) == SQLITE_ROW) {
        //获取执行的结果中，某一列的数据，并指定获取的类型（int, text...）,如果内部类型和获取的类型不一致，方法内部将会对内容进行类型转换
        NSString *japanese = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
        NSString *kana = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
        NSString *chinese = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
        NSString *type1 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
        NSString *type2 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
        NSInteger tone1 = sqlite3_column_int(statement, 5);
        NSInteger tone2 = sqlite3_column_int(statement, 6);

        NSInteger isHiragana = sqlite3_column_int(statement, 7);

        
        WordModel* word = [[WordModel alloc] init];
        word.japanese = japanese;
        word.kana = kana;
        word.chinese = chinese;
        word.type1 = type1;
        word.type2 = type2;
        word.type3 = @"";
        word.tone1 = tone1;
        word.tone2 = tone2;
        word.tone3 = -1;
        word.isHiragana = isHiragana;
        word.classname = @"";
        word.wordid = @"";
        word.audiofile = @"";
        word.starttime = 0;
        word.periodtime = 0;
        
        [wordsList addObject:word];
    }
    sqlite3_finalize(statement);//在内存中，清除之前准备的语句
    
    
    sqlite3_close(newWordsDB);//关闭数据库
    
    return [wordsList copy];
}


+(NSArray<WordModel*>*)allWords{
    
    if (![self dbFileExist]) {
        return nil;
    }
    
    char sql_stmt[1000];
    
    sqlite3 *newWordsDB; //Declare a pointer to sqlite database structure
    const char *dbpath = [[self dbPath] UTF8String]; // Convert NSString to UTF-8
    //打开数据库文件，没有则创建
    if (sqlite3_open(dbpath, &newWordsDB) == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
    sqlite3_stmt *statement;
    //－－－查－－－
    NSString* command = [NSString stringWithFormat:@"SELECT JAPANESE, KANA, CHINESE, TYPE1, TYPE2, TYPE3, TONE1, TONE2, TONE3, ISHIRAGANA , CLASSNAME, WORDID, AUDIOFILE, STARTTIME, PERIODTIME FROM NEWWORDS"];
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "%s", [command UTF8String]);
    //准备一个SQL语句，用于执行
    sqlite3_prepare_v2(newWordsDB, sql_stmt, -1, &statement, NULL);
    NSMutableArray* wordsList = [NSMutableArray array];
    //执行一条准备的语句,如果找到一行匹配的数据，则返回SQLITE_ROW
    while (sqlite3_step(statement) == SQLITE_ROW) {
        //获取执行的结果中，某一列的数据，并指定获取的类型（int, text...）,如果内部类型和获取的类型不一致，方法内部将会对内容进行类型转换
        NSString *japanese = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
        NSString *kana = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
        NSString *chinese = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
        NSString *type1 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
        NSString *type2 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
        NSString *type3 = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
        NSInteger tone1 = sqlite3_column_int(statement, 6);
        NSInteger tone2 = sqlite3_column_int(statement, 7);
        NSInteger tone3 = sqlite3_column_int(statement, 8);
        NSInteger isHiragana = sqlite3_column_int(statement, 9);
        
        NSString *classname = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 10)];
        NSString *wordid = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 11)];
        NSString *audiofile = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
        
        double startTime = sqlite3_column_double(statement, 13);
        double periodTime = sqlite3_column_double(statement, 14);
        
        WordModel* word = [[WordModel alloc] init];
        word.japanese = japanese;
        word.kana = kana;
        word.chinese = chinese;
        word.type1 = type1;
        word.type2 = type2;
        word.type3 = type3;
        word.tone1 = tone1;
        word.tone2 = tone2;
        word.tone3 = tone3;
        word.isHiragana = isHiragana;
        word.classname = classname;
        word.wordid = wordid;
        word.audiofile = audiofile;
        word.starttime = startTime;
        word.periodtime = periodTime;
        
        [wordsList addObject:word];
    }
    sqlite3_finalize(statement);//在内存中，清除之前准备的语句
    
    
    sqlite3_close(newWordsDB);//关闭数据库

    return [wordsList copy];
}
+(void)addWord:(WordModel*)word{
    
    if (!word) {
        return;
    }
    if (![self dbFileExist]) {
        return;
    }
    
    if (word.japanese.length == 0) {
        word.japanese = @"";
    }
    if (word.kana.length == 0) {
        word.kana = @"";
    }
    if (word.chinese.length == 0) {
        word.chinese = @"";
    }
    if (word.type1.length == 0) {
        word.type1 = @"";
    }
    if (word.type2.length == 0) {
        word.type2 = @"";
    }
    if (word.type3.length == 0) {
        word.type3 = @"";
    }
    if (word.classname.length == 0) {
        word.classname = @"";
    }
    if (word.wordid.length == 0) {
        word.wordid = @"";
    }
    if (word.audiofile.length == 0) {
        word.audiofile = @"";
    }
    
    char sql_stmt[1000];
    sqlite3 *newWordsDB; //Declare a pointer to sqlite database structure
    const char *dbpath = [[self dbPath] UTF8String]; // Convert NSString to UTF-8
    //打开数据库文件，没有则创建
    if (sqlite3_open(dbpath, &newWordsDB) == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
//    //创建表
//    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char),"CREATE TABLE IF NOT EXISTS NEWWORDS (ID INTEGER PRIMARY KEY AUTOINCREMENT, JAPANESE TEXT, KANA TEXT, CHINESE TEXT, TYPE1 TEXT, TYPE2 TEXT, TONE1 INTEGER, TONE2 INTEGER, ISHIRAGANA INTEGER)");
//    if (sqlite3_exec(newWordsDB, sql_stmt, NULL, NULL, NULL) == SQLITE_OK)
//    {
//        NSLog(@"创建表成功");
//    }else{
//        NSLog(@"创建表失败");
//    }
    
    //－－－增－－－
    NSString* addcommand = [NSString stringWithFormat:@"INSERT INTO NEWWORDS (JAPANESE, KANA, CHINESE, TYPE1, TYPE2, TYPE3, TONE1, TONE2, TONE3, ISHIRAGANA , CLASSNAME, WORDID, AUDIOFILE, STARTTIME, PERIODTIME) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%ld\",\"%ld\",\"%d\",\"%@\",\"%@\",\"%@\",\"%lf\",\"%lf\")",word.japanese,word.kana,word.chinese,word.type1,word.type2,word.type3,(long)word.tone1,(long)word.tone2,(long)word.tone3,word.isHiragana,word.classname,word.wordid,word.audiofile,word.starttime,word.periodtime];
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "%s", [addcommand UTF8String]);
    if (sqlite3_exec(newWordsDB, sql_stmt, NULL, NULL, NULL) == SQLITE_OK)
    {
        NSLog(@"成功增加一行");
    }
    sqlite3_close(newWordsDB);//关闭数据库
    
}
+(void)delWord:(WordModel*)word{
    if (![self dbFileExist]) {
        return;
    }
    char sql_stmt[1000];
    sqlite3 *newWordsDB; //Declare a pointer to sqlite database structure
    const char *dbpath = [[self dbPath] UTF8String]; // Convert NSString to UTF-8
    //打开数据库文件，没有则创建
    if (sqlite3_open(dbpath, &newWordsDB) == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
    //－－－删－－－
    NSString* command = [NSString stringWithFormat:@"DELETE FROM NEWWORDS WHERE KANA = \"%@\"",word.kana];
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "%s", [command UTF8String]);
    if (sqlite3_exec(newWordsDB, sql_stmt, NULL, NULL, NULL) == SQLITE_OK)
    {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}
+(BOOL)worldExist:(WordModel*)word{
    if (![self dbFileExist]) {
        return NO;
    }
    
    char sql_stmt[1000];
    sqlite3 *newWordsDB; //Declare a pointer to sqlite database structure
    const char *dbpath = [[self dbPath] UTF8String]; // Convert NSString to UTF-8
    //打开数据库文件，没有则创建
    if (sqlite3_open(dbpath, &newWordsDB) == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
    sqlite3_stmt *statement;
    //－－－查－－－
    NSString* command = [NSString stringWithFormat:@"SELECT * FROM NEWWORDS WHERE KANA = \"%@\"",word.kana];
    snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "%s", [command UTF8String]);
    //准备一个SQL语句，用于执行
    sqlite3_prepare_v2(newWordsDB, sql_stmt, -1, &statement, NULL);
    
    //执行一条准备的语句,如果找到一行匹配的数据，则返回SQLITE_ROW
    BOOL found = NO;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        //获取执行的结果中，某一列的数据，并指定获取的类型（int, text...）,如果内部类型和获取的类型不一致，方法内部将会对内容进行类型转换
        found = YES;
    }
    sqlite3_finalize(statement);//在内存中，清除之前准备的语句
    
    
    sqlite3_close(newWordsDB);//关闭数据库

    return found;
}

@end
