//
//  WJColorLabel.m
//  music-player
//
//  Created by mac on 16/3/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WJColorLabel.h"

@implementation WJColorLabel

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self currentColor];
    rect.size.width *= self.progress;
     UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
    
}
- (UIColor *)currentColor {
    if (_currentColor == nil) {
        _currentColor = [UIColor blueColor];
    }
    return _currentColor;
}
@end
