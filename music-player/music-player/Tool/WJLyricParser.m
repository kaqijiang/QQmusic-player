//
//  WJLyricParser.m
//  music-player
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WJLyricParser.h"
#import "WJLyricModel.h"

@implementation WJLyricParser
// 解析歌词的工具类
// fileName: 歌词文件名
+ (NSArray *)lyricParserWithFileName:(NSString *)fileName {
    //1 获取资源的url
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    //2 转成字符串
    NSString *lyricStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //3 截取这个字符串 根据\n
    NSArray *linesArray = [lyricStr componentsSeparatedByString:@"\n"];
    
    // 创建一个存放模型的数组
    NSMutableArray *modelArray = [NSMutableArray array];
    
    //4 再次截取
    for (NSString *line in linesArray) {
        //创建个范式 标准 [00:23.00] \\[[0-9][0-9]:[0-9][0-9].[0-9][0-9]\\]
        // 或者\\[\\d{2}:\\d{2}.\\d{2}\\]
        NSString *pattren = @"\\[\\d{2}:\\d{2}.\\d{2}\\]";
        //正则表达式
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattren options:0 error:nil];
        //与line匹配  matchesArray里边存的是 范式模型。
        NSArray *matchesArray = [regular matchesInString:line options:0 range:NSMakeRange(0, line.length)];
        //获取最后一个范式的范围
        NSTextCheckingResult *match = [matchesArray lastObject];
        //获取歌词文本  最后一个范式 的起始位置 加上自身的长度 开始截取
        NSString *content = [line substringFromIndex:match.range.location + match.range.length];
        //时间部分
        for (NSTextCheckingResult *timeMatch in matchesArray) {
            NSString *timeStr = [line substringWithRange:timeMatch.range];
            //创建时间格式化对象[00:00.00]
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            fmt.dateFormat = @"[mm:ss.SS]";
            NSDate *timeDate = [fmt dateFromString:timeStr];
            NSDate *zeroDate = [fmt dateFromString:@"[00:00.00]"];
            //歌词 时间
            NSTimeInterval time = [timeDate timeIntervalSinceDate:zeroDate];

            WJLyricModel *lyricModel = [[WJLyricModel alloc]init];
            lyricModel.content = content;
            lyricModel.time = time;
            //模型添加到数组中
            [modelArray addObject:lyricModel];
            
        }
    }
    /**
     *  要排序的key  ascending是否升序
     */
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    //排序
    return[modelArray sortedArrayUsingDescriptors:@[sort]];
;
}
@end
