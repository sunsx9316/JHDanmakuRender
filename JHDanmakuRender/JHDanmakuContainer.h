//
//  JHDanmakuContainer.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//  弹幕的容器 用来绘制弹幕

#import "JHDanmakuProtocol.h"
#import "JHDanmakuDefinition.h"

@class JHDanmakuEngine;
@interface JHDanmakuContainer : JHLabel
@property (weak, nonatomic, readonly) JHDanmakuEngine *danmakuEngine;
@property (strong, nonatomic) id<JHDanmakuProtocol> danmaku;

- (instancetype)initWithDanmaku:(id<JHDanmakuProtocol>)danmaku engine:(JHDanmakuEngine *)engine;

/**
 刷新当前弹幕属性
 */
- (void)updateAttributedByGlobalStyle;
/**
 *  更新位置
 *
 *  @param time 当前时间
 *
 *  @return 是否处于激活状态
 */
- (BOOL)updatePositionWithTime:(NSTimeInterval)time;

/// 重设初始位置
- (void)resetPosition;

/// 从画布中移除
- (void)removeFromCanvas;
@end
