//
//  AppDelegate.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PersistWords.h"
#import "WordModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AVOSCloud setApplicationId:@"kE5PXhVRVrRoKoDNMkdVE4c7-gzGzoHsz" clientKey:@"aGRwOxwVWSaBmrPT0xrsek1O"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    [AVObject fetchAll:nil];
//    WordModel* word = [[WordModel alloc] init];
//    word.japanese = @"";
//    word.kana = @"合う";
//    word.chinese = @"不知道";
//    word.type1 = @"动词";
//    word.type2 = @"xingrongci";
//    word.tone1 = 1;
//    word.tone2 = -1;
//    word.isHiragana = YES;
//    [PersistWords addWord:word];
//    [PersistWords delWord:word];
//    NSArray* words = [PersistWords allWords];
//    NSLog(@"%@",words);
//    NSLog(@"%d",[PersistWords worldExist:word]);
    [self initSVHUD];
    return YES;
}

- (void)initSVHUD{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:5];
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
