//
//  NarrowWordCell.h
//  RainbowGet
//
//  Created by Realank on 2017/4/25.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"

@interface NarrowWordCell : UITableViewCell

@property (nonatomic, strong) WordModel* word;
@property (nonatomic, assign) NSIndexPath* indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
