//
//  NarrowWordCell.m
//  RainbowGet
//
//  Created by Realank on 2017/4/25.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "NarrowWordCell.h"

@interface NarrowWordCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation NarrowWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [ThemeColor currentColor].tintColor;
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = [ThemeColor currentColor].selectedTintColor;
    _firstlineLabel.textColor = [ThemeColor currentColor].foreColor;
    _secondLineLabel.textColor = [ThemeColor currentColor].foreColor;
    _chineseLabel.textColor = [ThemeColor currentColor].foreColor;
    _typeLabel.textColor = DefaultGrayColor;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString* kCellIdentifier = [[self class] description];
    NarrowWordCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    }
    return cell;
}


+ (CGFloat)cellHeight{
    return 121.0f;
}

- (void)setWord:(WordModel *)word{
    _word = word;
    _secondLineLabel.text = word.japanese;
    _firstlineLabel.text = word.kana;
    _chineseLabel.text = word.chinese;
    
    _typeLabel.text = [NSString stringWithFormat:@"%@ %@",[word typeString],[word toneString]];
    
    if (_indexPath.row%2 == 0) {
        self.backgroundColor = [ThemeColor currentColor].tintColor;
    }else{
        self.backgroundColor = [ThemeColor currentColor].darkerTintColor;
    }
    
}

@end
