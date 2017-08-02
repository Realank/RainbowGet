//
//  AppDelegate.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudCrashReporting.h>
#import "PersistWords.h"
#import "WordModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AVOSCloudCrashReporting enable];
    [AVOSCloud setApplicationId:@"kE5PXhVRVrRoKoDNMkdVE4c7-gzGzoHsz" clientKey:@"aGRwOxwVWSaBmrPT0xrsek1O"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [self initSVHUD];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
//    NSArray* _fontFamilyArray = [UIFont familyNames];
//    NSMutableArray* _fontArray = [NSMutableArray array];
//    for (NSString* familyName in _fontFamilyArray) {
//        NSArray *fontArray = [UIFont fontNamesForFamilyName:familyName];
//        for (NSString* fontName in fontArray) {
//            NSLog(@"%@",fontName);
//        }
//    }
    return YES;
}

- (void)initSVHUD{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:5];
}

- (void)orientationChange:(NSNotification *)noti
{
    
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            
            
            break;
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            return;
            break;
        default:
            break;
    }
    
    if (![CommTool isIPAD]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OritationChanged" object:nil];
    }
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if ([CommTool isIPAD]) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
