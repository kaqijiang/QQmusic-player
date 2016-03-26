//
//  WJSliderView.m
//  music-player
//
//  Created by mac on 16/3/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WJSliderView.h"
#import "Masonry.h"
#import "WJFormatter.h"

@interface WJSliderView ()
@property( nonatomic,strong)UILabel *timeLabel;
@property( nonatomic,strong)UILabel *tipLabel;
@property( nonatomic,strong)UIButton *playBtn;
@property( nonatomic,strong)UIImageView *bgImageView;
@end

@implementation WJSliderView
//sb 加载
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}
//纯代码
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
//配置ui
- (void)configUI {
    //创建并初始化
    //时间
    self.timeLabel = [[UILabel alloc]init];
    [self addSubview:self.timeLabel];
    //内容
    self.tipLabel = [[UILabel alloc]init];
    [self addSubview:self.tipLabel];
    //背景
    self.bgImageView = [[UIImageView alloc]init];
    [self addSubview:self.bgImageView];
    //开始按钮
    self.playBtn = [[UIButton alloc]init];
    [self addSubview:self.playBtn];
    //添加按钮点击事件
    [self.playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    //设置属性
    self.tipLabel.text = @"从这里整么？—->";
    self.tipLabel.textColor = [UIColor whiteColor];
    self.bgImageView.image = [UIImage imageNamed:@"lyric_tipview_backimg"];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"slide_icon_play"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"slide_icon_play_pressed"] forState:UIControlStateHighlighted];
    self.timeLabel.textColor = [UIColor whiteColor];
    
}
//btn 点击事件
- (void)play {
    [[NSNotificationCenter defaultCenter]  postNotificationName:WJSliderViewNotification object:self];
}

//设置约束
- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(8);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-8);
    }];
}
#pragma mark- 给timelabel赋值
- (void)setTime:(NSTimeInterval)time {
    _time = time;
    self.timeLabel.text = [WJFormatter stringWithTimeInterval:time];
}
@end

NSString *WJSliderViewNotification = @"CZSliderViewNotification";
