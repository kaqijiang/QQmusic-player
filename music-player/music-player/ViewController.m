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

@interface ViewController ()

//开始按钮
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
//当前时间
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
//总时间
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
//滑块
@property (weak, nonatomic) IBOutlet UISlider *silder;
//歌词显示label
@property (weak, nonatomic) IBOutlet UILabel *lyricLabel;
//歌手label
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
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
    }else {
        //播放
        [musicTool playMusicWithFileName:musicModel.mp3];
    }
    self.playBtn.selected = !self.playBtn.selected;
}
//上一首歌
- (IBAction)previousBtnClicked {
    
}
//下一首歌
- (IBAction)nextBtnClicked {
    
}
//滑块
- (IBAction)silderClicked {
    
}
#pragma mark- UI界面配置
- (void)configUI {
    //从数组中取出当前歌曲模型数据。给界面赋值
    WJMusicModel *model = self.musicArray[self.currentMusicIndex];
    //歌手
    self.singerLabel.text = model.singer;
    //专辑
    self.albumLabel.text = model.album;
    //图片 取出图片 设置给头像和背景
    UIImage *image = [UIImage imageNamed:model.image];
    self.blackImageView.image = image;
    self.iconImageView.image = image;
    //创建单利
    WJPlayMusicTool *musicTool = [WJPlayMusicTool shareInstance];
    //设置总时间
    self.durationLabel.text = [self stringWithTimer:musicTool.duration];
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
