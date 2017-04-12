//
//  RLKNavigationController.m
//  RainbowGet
//
//  Created by Realank on 2017/4/6.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "RLKNavigationController.h"
#import "WordBoardViewController.h"

@interface RLKNavigationController ()

@end

@implementation RLKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//支持旋转
-(BOOL)shouldAutorotate{
    if ([CommTool isIPAD]) {
        return YES;
    }
    if ([self.viewControllers.lastObject isKindOfClass:[WordBoardViewController class]]) {
        return YES;
    }
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([CommTool isIPAD]) {
        return UIInterfaceOrientationMaskLandscape;
    }
    if ([self.viewControllers.lastObject isKindOfClass:[WordBoardViewController class]]) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}


@end
