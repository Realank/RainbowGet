//
//  BoardCell.h
//  RainbowGet
//
//  Created by Realank on 2017/3/1.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardCell : UICollectionViewCell

+ (NSString*)identifier;
+ (CGFloat)width;
+ (CGFloat)height;

@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* property;
@end
