//
//  WordModel.h
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WordModel : NSObject

@property (nonatomic, strong) NSString* japanese;
@property (nonatomic, strong) NSString* kana;
@property (nonatomic, strong) NSString* chinese;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, assign) NSInteger tone;
@property (nonatomic, assign) BOOL isHiragana;

- (NSString*)toneString;

@end
