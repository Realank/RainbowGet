//
//  WordModel.h
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
@class ClassModel;
@class WordModel;
@interface BookModel : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, strong) NSString* classesTableName;
@property (nonatomic, strong) NSString* wordsTableName;

@property (nonatomic, strong) NSArray<ClassModel*>* classes;

+ (void)loadBooksWithResult:(void (^)(NSArray<BookModel*>* books))resultBlock;
- (void)loadClassesWithComplete:(void (^)())completeBlock;
@end

@interface ClassModel : NSObject

@property (nonatomic, strong) NSString* classID;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* classTitle;
@property (nonatomic, copy) NSString* wordsTableName;
@property (nonatomic, copy) NSString* bookName;
@property (nonatomic, assign) BOOL hasAudio;

@property (nonatomic, strong) NSArray<WordModel*>* words;

- (void)loadWordsWithComplete:(void (^)())completeBlock;

- (NSString*)wordBookKey;
@end

@interface WordModel : NSObject

@property (nonatomic, strong) NSString* japanese;
@property (nonatomic, strong) NSString* kana;
@property (nonatomic, strong) NSString* chinese;
@property (nonatomic, strong) NSString* type1;
@property (nonatomic, strong) NSString* type2;
@property (nonatomic, strong) NSString* type3;
@property (nonatomic, assign) NSInteger tone1;
@property (nonatomic, assign) NSInteger tone2;
@property (nonatomic, assign) NSInteger tone3;
@property (nonatomic, assign) BOOL isHiragana;
@property (nonatomic, strong) NSString* classname;
@property (nonatomic, strong) NSString* wordid;
@property (nonatomic, strong) NSString* audiofile;
@property (nonatomic, assign) NSTimeInterval starttime;
@property (nonatomic, assign) NSTimeInterval periodtime;
- (NSString*)toneString;
- (NSString*)typeString;

@end
