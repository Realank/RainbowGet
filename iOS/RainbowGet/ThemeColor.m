//
//  ThemeColor.m
//  RainbowGet
//
//  Created by Realank on 2017/4/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "ThemeColor.h"
@interface ThemeColor ()

@end

@implementation ThemeColor

+(instancetype) currentColor {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(instancetype) initUniqueInstance {
    
    if (self = [super init]) {
        
        ThemeColor* newTheme = [ThemeColor allThemeColor].firstObject;
        self.foreColor = newTheme.foreColor;
        self.tintColor = newTheme.tintColor;
        self.selectedTintColor = newTheme.selectedTintColor;
        self.grayColor = newTheme.grayColor;
        self.themeName = newTheme.themeName;
    }
    return self;
}

+ (void)setTheme:(ThemeColor*)newTheme{
    ThemeColor* instanceTheme = [self currentColor];
    instanceTheme.foreColor = newTheme.foreColor;
    instanceTheme.tintColor = newTheme.tintColor;
    instanceTheme.selectedTintColor = newTheme.selectedTintColor;
    instanceTheme.grayColor = newTheme.grayColor;
    instanceTheme.themeName = newTheme.themeName;
}

+ (NSArray<ThemeColor*>*)allThemeColor{
    ThemeColor* blueTheme = [[ThemeColor alloc] init];
    blueTheme.themeName = @"低调蓝";
    blueTheme.foreColor = RGBColor(249,237,198,1);
    blueTheme.tintColor = RGBColor(22,73,90,1);
    blueTheme.selectedTintColor = RGBColor(12,63,80,1);
    blueTheme.grayColor = RGBColor(216,216,216,1);
    
    ThemeColor* greenTheme = [[ThemeColor alloc] init];
    greenTheme.themeName = @"黑板绿";
    greenTheme.foreColor = RGBColor(250,219,167,1);
    greenTheme.tintColor = RGBColor(31,102,86,1);
    greenTheme.selectedTintColor = RGBColor(21,92,76,1);
    greenTheme.grayColor = RGBColor(216,216,216,1);

    return @[blueTheme,greenTheme];
}


@end
