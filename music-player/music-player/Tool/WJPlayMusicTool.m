//
//  WJPlayMusicTool.m
//  music-player
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WJPlayMusicTool.h"
#import <AVFoundation/AVFoundation.h>

@interface WJPlayMusicTool ()
//播放音乐的对象
@property( nonatomic,strong)AVAudioPlayer *player;
@end

@implementation WJPlayMusicTool
//单利
+ (instancetype)shareInstance {
    static WJPlayMusicTool *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WJPlayMusicTool alloc]init];
    });
    return _instance;
}
//播放歌曲
- (void)playMusicWithFileName:(NSString *)fileName {
    //1.1url
    NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    //1.2error
    NSError *error = nil;
    
    //1 创建播放对象并且实例化
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    if (error) {
        NSLog(@"播放对象实例化失败,%@",error);
        return;
    }
    //2准备播放
    [self.player prepareToPlay];
    //3播放
    [self.player play];
}
//暂停
- (void)pause {
    [self.player pause];
}
//返回当前时间
- (NSTimeInterval)currentTime {
    return self.player.currentTime;
}
//返回总时间
- (NSTimeInterval)duration {
    return self.player.duration;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    self.player.currentTime = currentTime;
}

@end
