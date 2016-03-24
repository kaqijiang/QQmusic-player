//
//  ViewController.m
//  music-player
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

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
@end
