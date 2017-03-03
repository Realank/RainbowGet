//
//  WordModel.h
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>

@interface WordModel : NSObject

@property (nonatomic, strong) NSString* japanese;
@property (nonatomic, strong) NSString* kana;
@property (nonatomic, strong) NSString* chinese;
@property (nonatomic, strong) NSString* type1;
@property (nonatomic, strong) NSString* type2;
@property (nonatomic, assign) NSInteger tone1;
@property (nonatomic, assign) NSInteger tone2;
@property (nonatomic, assign) BOOL isHiragana;

- (NSString*)toneString;
- (NSString*)typeString;

+ (instancetype)wordWithAVObj:(AVObject*)obj;

@end
