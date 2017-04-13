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

+ (BOOL)hasAudioFile:(NSString*)fileName{
    if (fileName.length == 0) {
        return NO;
    }
    NSString *urlStr=[[NSBundle mainBundle]pathForResource:fileName ofType:@"mp3"];
    if (urlStr.length == 0) {
        NSLog(@"not found");
        return NO;
    }
    return YES;
}

+ (NetworkStatus)currentReachabilityType{
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    return reach.currentReachabilityStatus;
}

@end
