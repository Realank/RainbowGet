//
//  ViewController.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "ViewController.h"
#import "WordBoardViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self enter:nil];
}

- (IBAction)enter:(id)sender {
    WordBoardViewController* vc = [[WordBoardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
