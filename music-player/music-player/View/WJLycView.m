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
#import "WJSliderView.h"
#import "WJMusicModel.h"

@interface WJLycView ()<UIScrollViewDelegate>
@property( nonatomic,strong)UIScrollView *hScrollView;
@property( nonatomic,strong)UIScrollView *vScrollView;
@property( nonatomic,weak)WJSliderView *sliderView;
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
    //添加timelabel
    WJSliderView *sliderView = [[WJSliderView alloc]init];
    self.sliderView = sliderView;
    [self addSubview:self.sliderView];
    //隐藏
    self.sliderView.hidden = YES;
    //    测试
//        self.hScrollView.backgroundColor = [UIColor redColor];
        self.vScrollView.backgroundColor = [UIColor orangeColor];
    //设置代理
    self.hScrollView.delegate = self;
    self.vScrollView.delegate =self;
    self.hScrollView.showsHorizontalScrollIndicator = NO;
    self.hScrollView.pagingEnabled = YES;
    self.vScrollView.showsVerticalScrollIndicator = NO;
    self.hScrollView.bounces = NO;
    
}
//设置约束
-(void)layoutSubviews {
    NSLog(@"sss");
    [super layoutSubviews];
    
    [self.hScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.hScrollView.contentSize = CGSizeMake(2 * self.bounds.size.width, 0);

    [self.vScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self);
        make.left.mas_equalTo(self.bounds.size.width);
    }];

    //设置歌词界面的滚动。和中心
    [self layoutIfNeeded];
    //设置contentinset
    CGFloat top = self.vScrollView.bounds.size.height * 0.5;
    CGFloat bottom = top;
    NSLog(@"%f",top);
    self.vScrollView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.vScrollView.contentOffset = CGPointMake(0, -top);

    //设置slider内容约束
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self).offset(self.rowHight * 0.5);
    }];
    
}
#pragma mark- scrollView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //判断滚动的是哪个scrollView 横向
    if (self.hScrollView == scrollView) {
         [self hScrollViewDidScroll];
        
    } else if (self.vScrollView == scrollView) {

        //判断是纵向的滚动 根据contentoffset.y的值 判断第几行
        
       NSInteger cuttentHang = (self.vScrollView.contentOffset.y + self.vScrollView.contentInset.top) /self.rowHight;
  
        //取出歌词数组中的模型 再取出时间模型
        if (cuttentHang >= self.lycViewArray.count - 1) {
            cuttentHang = self.lycViewArray.count - 1;
        } else if (cuttentHang < 0){
            cuttentHang = 0;
        }
        WJLyricModel *timeModel = self.lycViewArray[cuttentHang];
        self.sliderView.time = timeModel.time;
        
    }
}
//滑动处理事件
- (void)hScrollViewDidScroll {
    CGFloat x = self.hScrollView.contentOffset.x;
    CGFloat progress = x / self.bounds.size.width;
    //代理传值 目的是让控制器隐藏view
    if ([self.delegate respondsToSelector:@selector(lyricView:hScrollViewDidScroll:)]) {
        [self.delegate lyricView:self hScrollViewDidScroll:progress];
    }
}
#pragma mark- scrollView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.vScrollView == scrollView) {
        self.sliderView.hidden = NO;
    }
}
//即将结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.vScrollView.isDragging) {
            self.sliderView.hidden = YES;
        }
    });
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
        CGFloat top = self.vScrollView.bounds.size.height * 0.5;
        CGFloat bottom = top;
        NSLog(@"%f",top);
        self.vScrollView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
        //设置slider内容约束
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self).offset(self.rowHight * 0.5);
        }];
    self.vScrollView.contentSize = CGSizeMake(0, self.rowHight * self.lycViewArray.count);
}

//当前行的set
- (void)setCurrentLycIndex:(NSInteger)currentLycIndex {
    //上一行 这里设置上一行字体大小
    if (self.currentLycIndex >= self.vScrollView.subviews.count - 1) {
        self.currentLycIndex = self.vScrollView.subviews.count - 1;
    }
    WJColorLabel *prelabel = self.vScrollView.subviews[self.currentLycIndex];
    prelabel.font = [UIFont systemFontOfSize:17];
    prelabel.progress = 0;
    
    _currentLycIndex = currentLycIndex;
    
//当前行label
    WJColorLabel *label = self.vScrollView.subviews[currentLycIndex];
    label.font = [UIFont systemFontOfSize:20];
    
    if (!self.sliderView.hidden) {
        return;
    }
    //动画滚动
    [UIView animateWithDuration:1 animations:^{
        
        self.vScrollView.contentOffset = CGPointMake(0, self.rowHight * currentLycIndex - self.vScrollView.bounds.size.height * 0.5);
    }];
    
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

