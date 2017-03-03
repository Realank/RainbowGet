//
//  ViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "ViewController.h"
#import "WordBoardViewController.h"
#import "ClassesListViewController.h"
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
    
    [ClassModel loadClassesWithResult:^(NSArray<ClassModel *> *classes) {
        if (classes.count <= 0) {
            return;
        }
        ClassesListViewController* vc = [[ClassesListViewController alloc] init];
        vc.classes = [classes copy];
        [self.navigationController pushViewController:vc animated:YES];
    }];

//    [WordModel loadWordsFromClass:@"Class2" result:^(NSArray<WordModel *>* words) {
//        if (words.count > 0) {
//            WordBoardViewController* vc = [[WordBoardViewController alloc] init];
//            vc.wordsList = [words copy];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
}


@end
