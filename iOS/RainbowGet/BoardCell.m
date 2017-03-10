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

+ (BOOL)isIPAD{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backView.layer.cornerRadius = 10;
    _backView.layer.borderWidth = 2;
    _backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _backView.backgroundColor = [UIColor colorWithRed:171/255.0 green:239/255.0 blue:1 alpha:1];
    if (![BoardCell isIPAD]) {
        _contentLabel.font = [UIFont systemFontOfSize:21];
    }
}

+ (NSString*)identifier{
    return @"BoardCell";
}

+ (CGFloat)width{
    if ([self isIPAD]) {
        return 330;
    }else{
        return 210;
    }
    
} 


+ (CGFloat)height{
    if ([self isIPAD]) {
        return 220;
    }else{
        return 120;
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    _contentLabel.text = content;
    if (content.length > 0) {
        _backView.backgroundColor = [UIColor colorWithRed:251/255.0 green:231/255.0 blue:195/255.0 alpha:1];
    }else{
        _backView.backgroundColor = [UIColor colorWithRed:230/255.0 green:231/255.0 blue:239/255.0 alpha:1];
    }
}
@end
