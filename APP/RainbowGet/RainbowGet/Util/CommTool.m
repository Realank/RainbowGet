//
//  CommTool.m
//  RainbowGet
//
//  Created by Realank on 2017/3/30.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "CommTool.h"
#import <UIKit/UIKit.h>

@implementation CommTool

+ (BOOL)isIPAD{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

+ (NSString*)bundleVersion{
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return bundleVersion;
}

+ (BOOL)isOritationHorizonal{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(orient)) {
        return NO;
    }
    return YES;
}

+ (double)screenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
@end
