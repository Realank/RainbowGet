//
//  ProtraitBoardCell.m
//  RainbowGet
//
//  Created by Realank on 2017/4/10.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "PortraitBoardCell.h"

@interface PortraitBoardCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;

@end

@implementation PortraitBoardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 8;
    //    _backView.layer.borderWidth = 2;
    //    _backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundColor = [ThemeColor currentColor].foreColor;
//    self.propertyLabel.textColor = [ThemeColor currentColor].grayColor;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.masksToBounds = NO;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString* kCellIdentifier = [[self class] description];
    PortraitBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    }
    return cell;
}

- (void)setContent:(NSString *)content{
    _content = content;
    _contentLabel.text = content;
}

- (void)setProperty:(NSString *)property{
    _property = property;
    _propertyLabel.text = property;
}

+ (CGFloat)cellHeight{
    double screenHeight = [UIScreen mainScreen].bounds.size.height;
    return (screenHeight - 64 - 15*3 - 10)/3;
}
@end
