//
//  WordBoardViewController.h
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"
@interface WordBoardViewController : UIViewController

@property (strong, nonatomic) ClassModel* aclass;
@property (assign, nonatomic) BOOL shouldBeginWithZero;

@end
