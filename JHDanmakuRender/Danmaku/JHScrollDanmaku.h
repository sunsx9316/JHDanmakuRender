//
//  JHScrollDanmaku.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHBaseDanmaku.h"

/**
 滚动弹幕方向
 
 - JHScrollDanmakuDirectionR2L: 从右到左
 - JHScrollDanmakuDirectionL2R: 从左到右
 - JHScrollDanmakuDirectionT2B: 从上到下
 - JHScrollDanmakuDirectionB2T: 从下到上
 */
typedef NS_ENUM(NSInteger, JHScrollDanmakuDirection) {
    JHScrollDanmakuDirectionR2L = 10,
    JHScrollDanmakuDirectionL2R = 11,
    JHScrollDanmakuDirectionT2B = 20,
    JHScrollDanmakuDirectionB2T = 21,
};

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *JHScrollDanmakuExtraSpeedKey;

@interface JHScrollDanmaku : JHBaseDanmaku

@property (assign, nonatomic, readonly) CGFloat speed;
@property (assign, nonatomic, readonly) JHScrollDanmakuDirection direction;

/**
 *  初始化 阴影 字体
 *
 *  @param font        字体
 *  @param text        文本内容
 *  @param textColor   文字颜色
 *  @param effectStyle 阴影风格
 *  @param direction   弹幕运动方向
 *
 *  @return self
 */

- (instancetype)initWithFont:(JHFont *)font
                        text:(NSString *)text
                   textColor:(JHColor *)textColor
                 effectStyle:(JHDanmakuEffectStyle)effectStyle
                   direction:(JHScrollDanmakuDirection)direction;
@end

NS_ASSUME_NONNULL_END
