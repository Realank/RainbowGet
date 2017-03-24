//
//  WordCell.m
//  RainbowGet
//
//  Created by Realank on 2017/3/21.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "WordCell.h"

@interface WordCell ()
@property (weak, nonatomic) IBOutlet UILabel *japaneseLabel;
@property (weak, nonatomic) IBOutlet UILabel *nakaLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation WordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = TINT_COLOR;
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = TINT_SELECTED_COLOR;
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
    return 60.0f;
}

- (void)setWord:(WordModel *)word{
    _word = word;
    if (word.japanese.length > 0) {
        _japaneseLabel.text = word.japanese;
        _nakaLabel.text = word.kana;
    }else{
        _japaneseLabel.text = word.kana;
        _nakaLabel.text = @"";
    }
    _chineseLabel.text = word.chinese;
    _typeLabel.text = [NSString stringWithFormat:@"%@\n%@",[word typeString],[word toneString]];
    
}

@end
