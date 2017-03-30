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

@end
