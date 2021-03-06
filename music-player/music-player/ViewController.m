//
//  ViewController.m
//  music-player
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "WJMusicModel.h"
#import "MJExtension.h"
#import "WJPlayMusicTool.h"
#import "WJLyricParser.h"
#import "WJLyricModel.h"
#import "WJColorLabel.h"
#import "WJLycView.h"
#import "WJSliderView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()<WjLycViewDelegate>

//开始按钮
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
//当前时间
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
//总时间
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
//滑块
@property (weak, nonatomic) IBOutlet UISlider *silder;
//歌词显示label
@property (weak, nonatomic) IBOutlet WJColorLabel *lyricLabel;
//歌手label
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
//存放头像的view
@property (weak, nonatomic) IBOutlet UIView *currentView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//专辑
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
//背景
@property (weak, nonatomic) IBOutlet UIImageView *blackImageView;
//数组 用来存放模型数据
@property( nonatomic,strong)NSArray *musicArray;
//设置一个索引 用来记录当前播放的歌曲 默认是0
@property( nonatomic,assign)NSInteger currentMusicIndex;
//定时器方法
@property( nonatomic,strong)NSTimer *timer;
// 接收解析过得歌词
@property (nonatomic, strong) NSArray *lyricsArray;
//定义判断是不是第一次点击播放
@property( nonatomic,assign)int num;
//用来存放scrollView视图
@property (weak, nonatomic) IBOutlet WJLycView *lycView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景玻璃化效果
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    toolbar.barStyle = UIBarStyleBlack;
    [self.blackImageView addSubview:toolbar];
    
    //设置自动约束
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    //配置UI界面
    [self configUI];
    
    //设置歌词view的代理
    self.lycView.delegate = self;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(silderPlay:) name:WJSliderViewNotification object:nil];
}
#pragma mark- 通知
- (void)silderPlay:(NSNotification *)notification {
    WJSliderView *slider = notification.object;
    
    WJPlayMusicTool * playMusic = [WJPlayMusicTool shareInstance];
    playMusic.currentTime = slider.time;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //切图
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width * 0.5;
    //切图
    self.iconImageView.layer.masksToBounds = YES;
}
//开始按钮点击事件
- (IBAction)begin {
    
    WJPlayMusicTool *musicTool = [WJPlayMusicTool shareInstance];
    //取出模型数据
    WJMusicModel *musicModel = self.musicArray[self.currentMusicIndex];
    //判断
    if (self.playBtn.selected) {
        [musicTool pause];
        //移除定时器
        [self turnOffTimer];
    }else {
        //播放
        [musicTool playMusicWithFileName:musicModel.mp3 didComplete:^{
            [self nextBtnClicked];
        }];
        //让定时器一开始不加载 不让头像转
         [self turnOnTimer];
        
    }
    self.playBtn.selected = !self.playBtn.selected;
}
//上一首歌
- (IBAction)previousBtnClicked {
    if (self.currentMusicIndex == 0) {
        self.currentMusicIndex = self.musicArray.count - 1;
    }else {
        self.currentMusicIndex--;
    }
    [self configUI];
    [self begin];
    self.iconImageView.transform = CGAffineTransformMakeRotation(0);
    self.silder.value = 0;
}
//下一首歌
- (IBAction)nextBtnClicked {
    if (self.currentMusicIndex == self.musicArray.count - 1) {
        self.currentMusicIndex = 0;
    }else {
        self.currentMusicIndex++;
    }
    [self configUI];
    [self begin];
    self.iconImageView.transform = CGAffineTransformMakeRotation(0);
    self.silder.value = 0;
}
//滑块
- (IBAction)silderClicked {
    WJPlayMusicTool *music = [WJPlayMusicTool shareInstance];
    music.currentTime = self.silder.value * music.duration;
}
#pragma mark- UI界面配置
- (void)configUI {
    //从数组中取出当前歌曲模型数据。给界面赋值
    WJMusicModel *musicModel = self.musicArray[self.currentMusicIndex];
    //歌手
    self.singerLabel.text = musicModel.singer;
    //专辑
    self.albumLabel.text = musicModel.album;
    //图片 取出图片 设置给头像和背景
    UIImage *image = [UIImage imageNamed:musicModel.image];
    self.blackImageView.image = image;
    self.iconImageView.image = image;
//    self.playBtn.selected = NO;
    //先移除一下
    [self turnOffTimer];
    //调用播放 为了出来总时间
    [self begin];
    //创建单利
    WJPlayMusicTool *musicTool = [WJPlayMusicTool shareInstance];
    //设置总时间
//    self.durationLabel.text = [self stringWithTimer:musicTool.duration];
    self.lyricsArray = [WJLyricParser lyricParserWithFileName:musicModel.lrc];
    if (!self.num) {
        [musicTool pause];
        self.playBtn.selected = NO;
         [self turnOffTimer];
        self.num++;
    }
    //给歌词界面歌词赋值
    self.lycView.lycViewArray = self.lyricsArray;
    
}
#pragma mark- 定时器创建移除
- (void)turnOnTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateWithTimer) userInfo:nil repeats:YES];
}
- (void)turnOffTimer {
    [self.timer invalidate];
    
}
#pragma mark- 定时器调用方法 动态设置数据
- (void)updateWithTimer {
    
    //头像旋转
    self.iconImageView.transform = CGAffineTransformRotate(self.iconImageView.transform, M_PI * 0.005);
    //创建播放工具单利
    WJPlayMusicTool *musicTool = [WJPlayMusicTool shareInstance];
    //滑块滚动
    self.silder.value = musicTool.currentTime / musicTool.duration;
    //当前时间
    self.currentLabel.text = [self stringWithTimer:musicTool.currentTime];
    self.durationLabel.text = [self stringWithTimer:musicTool.duration];
    //歌词
    [self updateWithLyric];
    
    // 锁屏界面信息
    [self lockScreen];
}
//锁屏信息
- (void)lockScreen {
    
    MPNowPlayingInfoCenter *nowPlayingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    WJMusicModel *musicModel = self.musicArray[self.currentMusicIndex];
    
    WJPlayMusicTool *musicTool = [WJPlayMusicTool shareInstance];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    /*  MPMediaItemPropertyAlbumTitle
     // MPMediaItemPropertyAlbumTrackCount
     // MPMediaItemPropertyAlbumTrackNumber
     // MPMediaItemPropertyArtist
     // MPMediaItemPropertyArtwork
     // MPMediaItemPropertyComposer
     // MPMediaItemPropertyDiscCount
     // MPMediaItemPropertyDiscNumber
     // MPMediaItemPropertyGenre
     // MPMediaItemPropertyPersistentID
     // MPMediaItemPropertyPlaybackDuration
     // MPMediaItemPropertyTitle               */
    dic[MPMediaItemPropertyAlbumTitle] = musicModel.album;
    
    dic[MPMediaItemPropertyArtist] = musicModel.singer;
    
    dic[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:musicModel.image]];
    
    dic[MPMediaItemPropertyPlaybackDuration] = @(musicTool.duration);
    
    dic[MPMediaItemPropertyTitle] = musicModel.name;
    
    dic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(musicTool.currentTime);
    
    nowPlayingInfoCenter.nowPlayingInfo = dic;

}

#pragma mark- 远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{   /*
     UIEventSubtypeRemoteControlPlay                 = 100,  播放
     UIEventSubtypeRemoteControlPause                = 101,  暂停
     UIEventSubtypeRemoteControlStop                 = 102,  停止
     UIEventSubtypeRemoteControlTogglePlayPause      = 103,  从播放到暂停
     UIEventSubtypeRemoteControlNextTrack            = 104,  下一曲
     UIEventSubtypeRemoteControlPreviousTrack        = 105,  上一曲
     UIEventSubtypeRemoteControlBeginSeekingBackward = 106,  开始快退
     UIEventSubtypeRemoteControlEndSeekingBackward   = 107,  结束快退
     UIEventSubtypeRemoteControlBeginSeekingForward  = 108,  开始快进
     UIEventSubtypeRemoteControlEndSeekingForward            结束快进
     */
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playBtn];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextBtnClicked];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousBtnClicked];
            break;
        default:
            break;
    }
}
#pragma mark- 歌词显示的方法
- (void)updateWithLyric {
    
    WJPlayMusicTool *musicTool = [WJPlayMusicTool shareInstance];
    for (NSInteger i = 0; i < self.lyricsArray.count; i++) {
        WJLyricModel *firstLyric = self.lyricsArray[i];
        WJLyricModel *nextLyric = nil;
        if (i == self.lyricsArray.count - 1) {
            nextLyric = self.lyricsArray[i];
        } else if (i < self.lyricsArray.count - 1){
            nextLyric = self.lyricsArray[i + 1];
        }
        //判断时间
        if (musicTool.currentTime >= firstLyric.time && musicTool.currentTime < nextLyric.time) {
            self.lyricLabel.text = firstLyric.content;
            
            CGFloat progress = (musicTool.currentTime - firstLyric.time) / (nextLyric.time - firstLyric.time);
            
            self.lyricLabel.progress = progress;
            //给歌词页赋值当前行
            self.lycView.currentLycIndex = i;
            //给歌词页赋值当前行进度
            self.lycView.progress = progress;
        }
    }
}
#pragma mark- 歌词view代理方法
- (void)lyricView:(WJLycView *)lyricView hScrollViewDidScroll:(CGFloat)progress {
    self.currentView.alpha = 1 - progress;
}
//时间转换
- (NSString *)stringWithTimer:(NSTimeInterval)time {
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}
#pragma mark- 懒加载
- (NSArray *)musicArray {
    
    if (!_musicArray) {
        _musicArray = [WJMusicModel objectArrayWithFilename:@"mlist.plist"];
    }
    return _musicArray;
}

@end
