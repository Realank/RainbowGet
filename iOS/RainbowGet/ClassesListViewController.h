//
//  ClassesListViewController.h
//  RainbowGet
//
//  Created by Realank on 2017/3/4.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassModel;
@interface ClassesListViewController : UITableViewController

@property (nonatomic, strong) NSArray<ClassModel*>* classes;

@end
