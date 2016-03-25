//
//  WJLycView.h
//  music-player
//
//  Created by mac on 16/3/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJLycView;
//声明协议
@protocol WjLycViewDelegate <NSObject>

- (void)lyricView:(WJLycView *)lyricView hScrollViewDidScroll:(CGFloat)progress;

@end

@interface WJLycView : UIView
//实现方法
@property(nonatomic, weak) id<WjLycViewDelegate> delegate;
//用来接收歌词数组
@property( nonatomic,strong)NSArray *lycViewArray;
//行高
@property( nonatomic,assign)CGFloat rowHight;
//当前行索引
@property( nonatomic,assign)NSInteger currentLycIndex;
//当前行进度
@property( nonatomic,assign)CGFloat progress;
@end
