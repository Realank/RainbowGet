//
//  ClassesListViewController.h
//  RainbowGet
//
//  Created by Realank on 2017/3/4.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassModel;
@protocol ClassListVCPushWordBoardDelegate <NSObject>

- (void)pushWordBoardToClass:(ClassModel*)aclass withFullScreen:(BOOL)fullScreen;

@end

@interface ClassesListViewController : UITableViewController <ClassListVCPushWordBoardDelegate>

@property (nonatomic, strong) NSArray<ClassModel*>* classes;

@end
