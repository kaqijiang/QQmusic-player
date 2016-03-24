//
//  WJPlayMusicTool.h
//  music-player
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPlayMusicTool : NSObject

//单利
+ (instancetype)shareInstance;
//总时间
@property( nonatomic,assign)NSTimeInterval duration;
//当前时间
@property( nonatomic,assign)NSTimeInterval currentTime;
//播放歌曲
- (void)playMusicWithFileName:(NSString *)fileName;
//暂停
- (void)pause;

@end
