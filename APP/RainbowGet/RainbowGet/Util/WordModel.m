//
//  WordModel.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "WordModel.h"
#import <AVOSCloud.h>

/*
 
 Hierarchy
 
 BookList
 | 
 MainBookName  WordsTable   ClassesTable
                    |           |
                WordsList---ClassList
 
 */

@interface WordModel ()

+ (instancetype)wordWithAVObj:(AVObject*)obj;

@end

@implementation BookModel

+ (void)loadBooksWithResult:(void (^)(NSArray<BookModel*>* books))resultBlock{
    
    AVQuery *query = [AVQuery queryWithClassName:@"BookList2_0"];
    [query orderByAscending:@"index"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count) {
                NSMutableArray* booksList = [NSMutableArray array];
                for (AVObject* obj in objects) {
                    
                    if (obj.allKeys > 0) {
                        BookModel* book = [[BookModel alloc] init];
                        book.title = obj[@"BookTitle"];
                        book.subtitle = obj[@"BookSubTitle"];
                        book.classesTableName = obj[@"ClassesTable"];
                        book.wordsTableName = obj[@"WordsTable"];
                        [booksList addObject:book];
                    }
                }
                if (booksList.count > 0) {
                    resultBlock([booksList copy]);
                    return;
                }
            }
        }
        resultBlock(nil);
    }];

}
- (void)loadClassesWithComplete:(void (^)())completeBlock{
    if (self.classes.count) {
        if (completeBlock) {
            completeBlock();
        }
        return;
    }
    AVQuery *queryMain = [AVQuery queryWithClassName:self.classesTableName];
    [queryMain orderByAscending:@"index"];
    [queryMain findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count) {
                NSMutableArray* classList = [NSMutableArray array];
                for (AVObject* obj in objects) {
                    
                    if (obj.allKeys > 0) {
                        ClassModel* aclass = [[ClassModel alloc] init];
                        aclass.classID = obj[@"ClassID"];
                        aclass.className = obj[@"ClassName"];
                        aclass.classTitle = obj[@"ClassTitle"];
                        aclass.wordsTableName = self.wordsTableName;
                        aclass.bookName = [NSString stringWithFormat:@"%@(%@)",self.title, self.subtitle];
                        [classList addObject:aclass];
                    }
                }
                if (classList.count > 0) {
                    self.classes = [classList copy];
                }
            }
        }else{
            
        }
        completeBlock();
    }];
}

@end
@implementation ClassModel

- (NSString*)wordBookKey{
    return [NSString stringWithFormat:@"%@-%@",self.bookName,self.className];
}

- (void)loadWordsWithComplete:(void (^)())completeBlock{
    if (self.words.count) {
        if (completeBlock) {
            completeBlock();
        }
        return;
    }
    AVQuery *query = [AVQuery queryWithClassName:self.wordsTableName];
    [query whereKey:@"classname" equalTo:self.classID];
    [query orderByAscending:@"wordid"];
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
                    self.words = [wordsList copy];
                    
                }
            }
        }
        if (completeBlock) {
            completeBlock();
        }
        
    }];
}

@end



@implementation WordModel

- (NSString*)toneStringWithIndex:(NSInteger)index{
    switch (index) {
        case -1:
            return @"";
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
    return [NSString stringWithFormat:@"%@%@%@",[self toneStringWithIndex:self.tone1],[self toneStringWithIndex:self.tone2],[self toneStringWithIndex:self.tone3]];
}

- (NSString *)typeString{
    if (self.type2.length <= 0) {
        return self.type1;
    }
    if (self.type3.length <= 0) {
        return [NSString stringWithFormat:@"%@·%@",self.type1,self.type2];
    }
    
    return [NSString stringWithFormat:@"%@·%@·%@",self.type1,self.type2,self.type3];
    
}

+ (instancetype)wordWithAVObj:(AVObject*)obj{
    
    if (obj.allKeys.count > 0) {
        WordModel* word = [[WordModel alloc] init];
        word.japanese = obj[@"japanese"];
        word.kana = obj[@"kana"];
        word.chinese = obj[@"chinese"];
        word.tone1 = [obj[@"tone1"] integerValue];
        word.tone2 = [obj[@"tone2"] integerValue];
        word.tone3 = [obj[@"tone3"] integerValue];
        word.type1 = obj[@"type1"];
        word.type2 = obj[@"type2"];
        word.type3 = obj[@"type3"];
        word.classname = obj[@"classname"];
        word.wordid = obj[@"wordid"];
        word.audiofile = obj[@"audiofile"];
        word.audiofile = [word.audiofile stringByReplacingOccurrencesOfString:@"MW" withString:@"WD"];
        word.isHiragana = [obj[@"ishiragana"] boolValue];
        word.starttime = [obj[@"starttime"] doubleValue];
        word.periodtime = [obj[@"periodtime"] doubleValue];
        return word;
    }
    return nil;
}

@end
