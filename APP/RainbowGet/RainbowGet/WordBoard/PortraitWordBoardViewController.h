//
//  PortraitWordBoardViewController.h
//  RainbowGet
//
//  Created by Realank on 2017/4/7.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassesListViewController.h"
@interface PortraitWordBoardViewController : UITableViewController
@property (strong, nonatomic) ClassModel* aclass;
@property (assign, nonatomic) BOOL shouldBeginWithZero;
@property (weak, nonatomic) id<ClassListVCPushWordBoardDelegate> pushWordBoardDeleagte;
@end
