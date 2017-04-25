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
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;

@end

@implementation BoardCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backView.layer.cornerRadius = 8;
//    _backView.layer.borderWidth = 2;
//    _backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _backView.backgroundColor = [ThemeColor currentColor].foreColor;
    if (![CommTool isIPAD]) {
        _contentLabel.font = [UIFont systemFontOfSize:21];
        _propertyLabel.font = [UIFont systemFontOfSize:17];
    }
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.masksToBounds = NO;
}

+ (NSString*)identifier{
    return @"BoardCell";
}

+ (CGFloat)width{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight =[UIScreen mainScreen].bounds.size.height;
    screenWidth = MAX(screenWidth, screenHeight);
    CGFloat width = (screenWidth - 40)/3;
    if ([CommTool isIPAD]) {
        if (width > 330) {
            width = 330;
        }
    }else{
        if (width > 210) {
            width = 210;
        }
    }
    return width;
    
} 


+ (CGFloat)height{
    if ([CommTool isIPAD]) {
        return 220;
    }else{
        return 120;
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    _contentLabel.text = content;
    if (content.length > 0) {
        _backView.backgroundColor = [ThemeColor currentColor].foreColor;
    }else{
        _backView.backgroundColor = DefaultGrayColor;
    }
}

- (void)setProperty:(NSString *)property{
    _property = property;
    _propertyLabel.text = property;
}
@end
