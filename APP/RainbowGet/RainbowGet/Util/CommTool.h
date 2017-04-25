//
//  CommTool.h
//  RainbowGet
//
//  Created by Realank on 2017/3/30.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CommTool : NSObject

+ (BOOL)isIPAD;
+ (double)commCellHeight;
+ (NSString*)bundleVersion;

+ (BOOL)isOritationHorizonal;

+ (double)screenWidth;

+ (BOOL)hasAudioFile:(NSString*)fileName;

+ (NetworkStatus)currentReachabilityType;
@end
