//
//  WJLycView.m
//  music-player
//
//  Created by mac on 16/3/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WJLycView.h"
#import "Masonry.h"
#import "WJLyricModel.h"
#import "WJColorLabel.h"

@interface WJLycView ()<UIScrollViewDelegate>
@property( nonatomic,strong)UIScrollView *hScrollView;
@property( nonatomic,strong)UIScrollView *vScrollView;
@end

@implementation WJLycView
//get set方法同时存在时得加上这个中介。
@synthesize currentLycIndex = _currentLycIndex;
//xib加载
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}
//纯代码加载
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
//设置
- (void)setupUI {
    
    //初始化scrollView
    UIScrollView *hScrollView = [[UIScrollView alloc]init];
    UIScrollView *vScrollView = [[UIScrollView alloc]init];
    self.hScrollView = hScrollView;
    self.vScrollView = vScrollView;
    [self addSubview:hScrollView];
    [self.hScrollView addSubview:vScrollView];
    //    测试
//        self.hScrollView.backgroundColor = [UIColor redColor];
        self.vScrollView.backgroundColor = [UIColor orangeColor];
    //设置代理
    self.hScrollView.delegate = self;
    
    self.hScrollView.showsHorizontalScrollIndicator = NO;
    self.hScrollView.pagingEnabled = YES;
    self.vScrollView.showsVerticalScrollIndicator = NO;
    self.hScrollView.bounces = NO;
    
}
//设置约束
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.hScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.hScrollView.contentSize = CGSizeMake(2 * self.bounds.size.width, 0);

    [self.vScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self);
        make.left.mas_equalTo(self.bounds.size.width);
    }];

    [self layoutIfNeeded];
    
    //设置contentinset
    self.vScrollView.contentInset = UIEdgeInsetsMake(300, 0, self.vScrollView.bounds.size.height * 0.5, 0);
}
#pragma mark- scrollView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //判断滚动的是哪个scrollView
    if (self.hScrollView == scrollView) {
         [self hScrollViewDidScroll];
    }
}
//滑动处理事件
- (void)hScrollViewDidScroll {
    CGFloat x = self.hScrollView.contentOffset.x;
    CGFloat progress = x / self.bounds.size.width;
    if ([self.delegate respondsToSelector:@selector(lyricView:hScrollViewDidScroll:)]) {
        [self.delegate lyricView:self hScrollViewDidScroll:progress];
    }
}
//歌词数组的set方法
- (void)setLycViewArray:(NSArray *)lycViewArray {
    _lycViewArray = lycViewArray;
    //移除上一次创建的label
    [self.vScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建label
    for (int i = 0; i < lycViewArray.count; i++) {
        WJLyricModel *model = lycViewArray[i];
        WJColorLabel *label = [[WJColorLabel alloc]init];
        label.text = model.content;
        label.textColor = [UIColor yellowColor];
        //添加到垂直滚动
        [self.vScrollView addSubview:label];
        //设置约束
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//          make.centerY.mas_equalTo(self).offset(self.rowHight * i);
            make.top.mas_equalTo(self.rowHight * i);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(self.rowHight);
        }];
    }
    self.vScrollView.contentSize = CGSizeMake(0, self.rowHight * self.lycViewArray.count);
}

//当前行的set
- (void)setCurrentLycIndex:(NSInteger)currentLycIndex {
    //上一行 这里设置上一行字体大小
    WJColorLabel *prelabel = self.vScrollView.subviews[self.currentLycIndex];
    prelabel.font = [UIFont systemFontOfSize:17];
    prelabel.progress = 0;
    
    _currentLycIndex = currentLycIndex;
    
//当前行label
    WJColorLabel *label = self.vScrollView.subviews[currentLycIndex];
    label.font = [UIFont systemFontOfSize:20];
}
//当前索引的get方法
- (NSInteger)currentLycIndex {
    if (_currentLycIndex < 0) {
        _currentLycIndex = 0;
    }else if (_currentLycIndex > self.vScrollView.subviews.count -1) {
        _currentLycIndex = self.vScrollView.subviews.count;
    }
    return _currentLycIndex;
}
//当前行进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    WJColorLabel *label = self.vScrollView.subviews[self.currentLycIndex];
    label.progress = progress;
}
- (CGFloat)rowHight {
    if (!_rowHight) {
        _rowHight = 30;
    }
    return _rowHight;
}


@end









