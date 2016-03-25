//
//  WJFormatter.m
//  music-player
//
//  Created by mac on 16/3/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WJFormatter.h"

@implementation WJFormatter
#pragma mark - 时间间隔 转 字符串
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)time
{   // 分钟
    int minute = time / 60;
    // 秒
    int second = (int)time % 60;
    // 返回字符串
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}
@end
