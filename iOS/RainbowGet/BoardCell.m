//
//  BoardCell.m
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "BoardCell.h"

@interface BoardCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation BoardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backView.layer.cornerRadius = 10;
    _backView.layer.borderWidth = 2;
    _backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

+ (NSString*)identifier{
    return @"BoardCell";
}

+ (CGFloat)width{
    return 330;
}


+ (CGFloat)height{
    return 220;
}

- (void)setContent:(NSString *)content{
    _content = content;
    _contentLabel.text = content;
}
@end
