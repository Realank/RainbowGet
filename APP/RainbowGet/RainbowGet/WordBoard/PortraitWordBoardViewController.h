//
//  PortraitWordBoardViewController.h
//  RainbowGet
//
//  Created by Realank on 2017/4/10.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassesListViewController.h"
@interface PortraitWordBoardViewController : UIViewController

@property (strong, nonatomic) ClassModel* aclass;
@property (assign, nonatomic) BOOL shouldBeginWithZero;
@property (weak, nonatomic) id<ClassListVCPushWordBoardDelegate> pushWordBoardDeleagte;

@end
