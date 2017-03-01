//
//  WordModel.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel

- (NSString*)toneString{
    switch (self.tone) {
        case 0:
            return @"⓪";
        case 1:
            return @"①";
        case 2:
            return @"②";
        case 3:
            return @"③";
        case 4:
            return @"④";
        case 5:
            return @"⑤";
        case 6:
            return @"⑥";
        case 7:
            return @"⑦";
        case 8:
            return @"⑧";
        case 9:
            return @"⑨";
        default:
            return @"ⓝ";
    }
}

@end
