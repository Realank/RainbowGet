//
//  WordCell.m
//  RainbowGet
//
//  Created by Realank on 2017/3/21.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "WordCell.h"

@interface WordCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation WordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [ThemeColor currentColor].tintColor;
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = [ThemeColor currentColor].selectedTintColor;
    for (id subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel* label = subView;
            label.textColor = [ThemeColor currentColor].foreColor;
        }
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString* kCellIdentifier = [[self class] description];
    WordCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    }
    return cell;
}


+ (CGFloat)cellHeight{
    return 80.0f;
}

- (void)setWord:(WordModel *)word{
    _word = word;
    _secondLabel.text = word.japanese;
    _firstLabel.text = word.kana;
    _chineseLabel.text = word.chinese;
    
    if ([word typeString].length > 6) {
        _typeLabel.text = [NSString stringWithFormat:@"%@ %@",[word typeString],[word toneString]];
    }else{
        _typeLabel.text = [NSString stringWithFormat:@"%@\n%@",[word typeString],[word toneString]];
    }
    
    
    
}

@end
