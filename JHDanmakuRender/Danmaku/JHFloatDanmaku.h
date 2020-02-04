//
//  JHFloatDanmaku.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//
#import "JHBaseDanmaku.h"
#import "JHDanmakuDefinition.h"

/**
 浮动弹幕位置
 
 - JHFloatDanmakuPositionAtBottom: 在底部
 - JHFloatDanmakuPositionAtTop: 在顶部
 */
typedef NS_ENUM(NSUInteger, JHFloatDanmakuPosition) {
    JHFloatDanmakuPositionAtBottom = 100,
    JHFloatDanmakuPositionAtTop
};

NS_ASSUME_NONNULL_BEGIN
@interface JHFloatDanmaku : JHBaseDanmaku

/**
 *  初始化 阴影 字体
 *
 *  @param font        字体
 *  @param text        文本
 *  @param textColor   文字颜色(务必使用 colorWithRed:green:blue:alpha初始化)
 *  @param effectStyle 阴影类型
 *  @param during      弹幕持续时间
 *  @param position   弹幕方向
 *
 *  @return self
 */
- (instancetype)initWithFont:(JHFont * _Nullable)font
                        text:(NSString * _Nullable)text
                   textColor:(JHColor * _Nullable)textColor
                 effectStyle:(JHDanmakuEffectStyle)effectStyle
                      during:(CGFloat)during
                    position:(JHFloatDanmakuPosition)position;

@property (assign, nonatomic, readonly) CGFloat during;
@property (assign, nonatomic, readonly) JHFloatDanmakuPosition position;

@end

NS_ASSUME_NONNULL_END
