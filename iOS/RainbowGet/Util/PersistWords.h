//
//  PersistWords.h
//  RainbowGet
//
//  Created by Realank on 2017/3/16.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordModel.h"

@interface PersistWords : NSObject

+(NSArray<WordModel*>*)allWords;
+(void)addWord:(WordModel*)word;
+(void)delWord:(WordModel*)word;
+(BOOL)worldExist:(WordModel*)word;

@end
