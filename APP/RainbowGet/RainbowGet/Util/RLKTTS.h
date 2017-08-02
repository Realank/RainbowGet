//
//  RLKTTS.h
//  TTS
//
//  Created by Realank on 2017/8/2.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLKTTS : NSObject

+ (void)stop;
+ (void)speekChinese:(NSString*)chinese complete:(void(^)())completeBlock;

@end
