//
//  WJLyricParser.h
//  music-player
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJLyricParser : NSObject
// 解析歌词的工具类
// fileName: 歌词文件名
+ (NSArray *)lyricParserWithFileName:(NSString *)fileName;
@end
