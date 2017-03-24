//
//  WordModel.h
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>

@interface ClassModel : NSObject

@property (nonatomic, strong) NSString* classID;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* book;

+ (void)loadClassesWithResult:(void (^)(NSArray<ClassModel*>* classes))resultBlock;
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

+ (instancetype)wordWithAVObj:(AVObject*)obj;
+ (void)loadWordsFromClass:(NSString *)classID result:(void (^)(NSArray<WordModel*>* words))resultBlock;

@end
