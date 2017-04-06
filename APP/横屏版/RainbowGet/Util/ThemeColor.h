//
//  ThemeColor.h
//  RainbowGet
//
//  Created by Realank on 2017/4/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeColor : NSObject

@property (nonatomic, strong) NSString* themeName;
@property (nonatomic, strong) UIColor* foreColor;
@property (nonatomic, strong) UIColor* tintColor;
@property (nonatomic, strong) UIColor* selectedTintColor;
@property (nonatomic, strong) UIColor* grayColor;

+ (void)setTheme:(ThemeColor*)newTheme;
+ (instancetype) currentColor;
+ (NSArray<ThemeColor*>*)allThemeColor;
+ (instancetype)customTheme;
@end
