//
//  ThemeColor.h
//  RainbowGet
//
//  Created by Realank on 2017/4/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DefaultGrayColor RGBColor(216,216,216,1)
@interface ThemeColor : NSObject

@property (nonatomic, strong) NSString* themeName;
@property (nonatomic, strong) UIColor* foreColor;
@property (nonatomic, strong) UIColor* tintColor;
@property (nonatomic, strong, readonly) UIColor* selectedTintColor;
@property (nonatomic, strong, readonly) UIColor* darkerTintColor;
+ (void)setTheme:(ThemeColor*)newTheme;
+ (instancetype) currentColor;
+ (NSArray<ThemeColor*>*)allThemeColor;
+ (instancetype)customTheme;
@end
