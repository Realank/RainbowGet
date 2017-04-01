//
//  ThemeColor.m
//  RainbowGet
//
//  Created by Realank on 2017/4/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "ThemeColor.h"
#define DefaultGrayColor RGBColor(216,216,216,1)

@interface UIColor (Dictionary)

@end

@implementation UIColor (Dictionary)

- (NSDictionary*)toDict{
    CGFloat red,green,blue;
    [self getRed:&red green:&green blue:&blue alpha:NULL];
    return @{
            @"red":@(red),
            @"green":@(green),
            @"blue":@(blue),
             };
}

+ (instancetype)colorWithDict:(NSDictionary*)dict{
    if (dict.allKeys.count != 3) {
        return nil;
    }
    CGFloat red = [dict[@"red"] floatValue];;
    CGFloat green = [dict[@"green"] floatValue];
    CGFloat blue = [dict[@"blue"] floatValue];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

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

//@property (nonatomic, strong) NSString* themeName;
//@property (nonatomic, strong) UIColor* foreColor;
//@property (nonatomic, strong) UIColor* tintColor;
//@property (nonatomic, strong) UIColor* selectedTintColor;
//@property (nonatomic, strong) UIColor* grayColor;

- (NSDictionary*)toDict{
    return @{
            @"themeName":self.themeName,
            @"foreColor":[self.foreColor toDict],
            @"tintColor":[self.tintColor toDict],
            @"selectedTintColor":[self.selectedTintColor toDict],
            @"grayColor":[self.grayColor toDict],
            };
}

+ (instancetype)themeWithDict:(NSDictionary*)dict{
    if (dict.allKeys.count < 5) {
        return nil;
    }
    ThemeColor* theme = [[ThemeColor alloc] init];
    theme.themeName = dict[@"themeName"];
    theme.foreColor = [UIColor colorWithDict:dict[@"foreColor"]];
    theme.tintColor = [UIColor colorWithDict:dict[@"tintColor"]];
    theme.selectedTintColor = [UIColor colorWithDict:dict[@"selectedTintColor"]];
    theme.grayColor = [UIColor colorWithDict:dict[@"grayColor"]];
    return theme;
}

-(instancetype) initUniqueInstance {
    
    if (self = [super init]) {
        
        NSString* previousThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"PreviousThemeName"];
        ThemeColor* newTheme = nil;
        for (newTheme in [ThemeColor allThemeColor]) {
            if ([previousThemeName isEqualToString:newTheme.themeName]) {
                break;
            }
        }
        if (!newTheme) {
            newTheme = [ThemeColor allThemeColor].firstObject;
        }
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
    if ([newTheme.themeName isEqualToString:@"自定义"]) {
        NSDictionary* customThemeDict = [newTheme toDict];
        if (customThemeDict) {
            [[NSUserDefaults standardUserDefaults] setObject:customThemeDict forKey:@"ThemeColorCustomColor"];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:newTheme.themeName forKey:@"PreviousThemeName"];
}

+ (instancetype)customTheme{
    ThemeColor* newTheme = nil;
    for (newTheme in [ThemeColor allThemeColor]) {
        if ([@"自定义" isEqualToString:newTheme.themeName]) {
            break;
        }
    }
    if (!newTheme) {
        newTheme = [ThemeColor allThemeColor].firstObject;
    }
    return newTheme;
}

+ (NSArray<ThemeColor*>*)allThemeColor{
    ThemeColor* blueTheme = [[ThemeColor alloc] init];
    blueTheme.themeName = @"低调蓝";
    blueTheme.foreColor = RGBColor(249,237,198,1);
    blueTheme.tintColor = RGBColor(43,103,123,1);
    blueTheme.selectedTintColor = RGBColor(33,93,113,1);
    blueTheme.grayColor = DefaultGrayColor;
    
    ThemeColor* greenTheme = [[ThemeColor alloc] init];
    greenTheme.themeName = @"黑板绿";
    greenTheme.foreColor = RGBColor(250,219,167,1);
    greenTheme.tintColor = RGBColor(31,102,86,1);
    greenTheme.selectedTintColor = RGBColor(21,92,76,1);
    greenTheme.grayColor = DefaultGrayColor;
    
    ThemeColor* customTheme = [self themeWithDict:[[NSUserDefaults standardUserDefaults]objectForKey:@"ThemeColorCustomColor"]];
    if (!customTheme || ![customTheme.themeName isEqualToString:@"自定义"]) {
        customTheme = [[ThemeColor alloc] init];
        customTheme.themeName = @"自定义";
        customTheme.foreColor = RGBColor(249,237,198,1);
        customTheme.tintColor = RGBColor(38,116,142,1);
        customTheme.selectedTintColor = RGBColor(28,106,132,1);
        customTheme.grayColor = DefaultGrayColor;
        NSDictionary* customThemeDict = [customTheme toDict];
        if (customThemeDict) {
            [[NSUserDefaults standardUserDefaults] setObject:customThemeDict forKey:@"ThemeColorCustomColor"];
        }
    }

    return @[blueTheme,greenTheme,customTheme];
}


@end
