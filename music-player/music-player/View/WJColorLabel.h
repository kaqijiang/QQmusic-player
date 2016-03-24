//
//  WJColorLabel.h
//  music-player
//
//  Created by mac on 16/3/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJColorLabel : UILabel
// 进度
@property (nonatomic, assign) CGFloat progress;
// 颜色
@property (nonatomic, strong) UIColor *currentColor;
@end
