//
//  BookCell.m
//  RainbowGet
//
//  Created by Realank on 2017/3/30.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "BookCell.h"

@interface BookCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation BookCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.masksToBounds = NO;
    self.backgroundColor = FORE_COLOR;
}

- (void)setBook:(BookModel *)book{
    _book = book;
    _titleLabel.text = book.title;
    _subTitleLabel.text = book.subtitle;
}

@end
