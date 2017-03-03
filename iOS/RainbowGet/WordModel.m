//
//  WordModel.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "WordModel.h"
#import <AVOSCloud.h>

@implementation ClassModel

+ (void)loadClassesWithResult:(void (^)(NSArray<ClassModel*>* classes))resultBlock{
    AVQuery *query = [AVQuery queryWithClassName:@"ClassList"];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count) {
                NSMutableArray* classList = [NSMutableArray array];
                for (AVObject* obj in objects) {
                    
                    if (obj.allKeys > 0) {
                        ClassModel* class = [[ClassModel alloc] init];
                        class.classID = obj[@"ClassID"];
                        class.className = obj[@"ClassName"];
                        [classList addObject:class];
                    }
                }
                if (classList.count > 0) {
                    resultBlock([classList copy]);
                    return;
                }
            }
        }
        resultBlock(nil);
    }];
}

@end

@implementation WordModel

- (NSString*)toneStringWithIndex:(NSInteger)index{
    switch (index) {
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

- (NSString *)toneString{
    if (self.tone2 < 0) {
        return [self toneStringWithIndex:self.tone1];
    }
    return [NSString stringWithFormat:@"%@%@",[self toneStringWithIndex:self.tone1],[self toneStringWithIndex:self.tone2]];
}

- (NSString *)typeString{
    if (self.type2.length <= 0) {
        return self.type1;
    }
    
    return [NSString stringWithFormat:@"%@·%@",self.type1,self.type2];
}

+ (instancetype)wordWithAVObj:(AVObject*)obj{
    
    if (obj.allKeys.count > 0) {
        WordModel* word = [[WordModel alloc] init];
        word.japanese = obj[@"japanese"];
        word.kana = obj[@"kana"];
        word.chinese = obj[@"chinese"];
        word.tone1 = [obj[@"tone1"] integerValue];
        word.type1 = obj[@"type1"];
        word.tone2 = [obj[@"tone2"] integerValue];
        word.type2 = obj[@"type2"];
        word.isHiragana = [obj[@"ishiragana"] boolValue];
        return word;
    }
    return nil;
}

+ (void)loadWordsFromClass:(NSString *)classID result:(void (^)(NSArray<WordModel*>* words))resultBlock{
    AVQuery *query = [AVQuery queryWithClassName:classID];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count) {
                NSMutableArray* wordsList = [NSMutableArray array];
                for (AVObject* obj in objects) {
                    
                    WordModel* word = [WordModel wordWithAVObj:obj];
                    if (obj) {
                        [wordsList addObject:word];
                    }
                }
                if (wordsList.count > 0) {
                    resultBlock([wordsList copy]);
                    return;
                }
            }
        }
        resultBlock(nil);
    }];
}
@end
