//
//  ViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "ViewController.h"
#import "WordBoardViewController.h"
#import <AVOSCloud.h>
#import "WordModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self enter:nil];
}

- (IBAction)enter:(id)sender {
    AVQuery *query = [AVQuery queryWithClassName:@"Class1"];
    [query orderByDescending:@"createdAt"];
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
                WordBoardViewController* vc = [[WordBoardViewController alloc] init];
                vc.wordsList = [wordsList copy];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}


@end
