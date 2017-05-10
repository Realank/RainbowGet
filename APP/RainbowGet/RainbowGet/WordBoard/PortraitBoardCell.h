//
//  ProtraitBoardCell.h
//  RainbowGet
//
//  Created by Realank on 2017/4/10.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortraitBoardCell : UITableViewCell
@property (nonatomic, assign) BOOL useJapsnFont;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* property;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
