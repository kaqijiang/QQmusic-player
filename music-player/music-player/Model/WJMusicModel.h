//
//  WJMusicModel.h
//  music-player
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//定义类型枚举
typedef enum {
    kMusicTypeLocal, //本地
    kMusicTypeRemote //远程
}kMusicType;

@interface WJMusicModel : NSObject

//图片
@property(nonatomic,copy)NSString *image;
//歌词
@property(nonatomic,copy)NSString *lrc;
//歌曲名
@property(nonatomic,copy)NSString *mp3;
//名字
@property(nonatomic,copy)NSString *name;
//歌手名
@property(nonatomic,copy)NSString *singer;
//专辑
@property(nonatomic,copy)NSString *album;
//类别
@property(nonatomic,assign)kMusicType type;

@end
