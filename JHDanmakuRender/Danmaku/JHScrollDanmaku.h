//
//  JHScrollDanmaku.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHBaseDanmaku.h"

typedef NS_ENUM(NSInteger, JHScrollDanmakuDirection) {
    JHScrollDanmakuDirectionR2L = 10,
    JHScrollDanmakuDirectionL2R = 11,
    JHScrollDanmakuDirectionT2B = 20,
    JHScrollDanmakuDirectionB2T = 21,
};

@interface JHScrollDanmaku : JHBaseDanmaku
/**
 *  初始化 阴影 字体
 *
 *  @param fontSize    文字大小(在font为空时有效)
 *  @param textColor   文字颜色(务必使用 colorWithRed:green:blue:alpha初始化)
 *  @param text        文本内容
 *  @param shadowStyle 阴影风格
 *  @param font        字体
 *  @param speed       弹幕速度
 *  @param direction   弹幕运动方向
 *
 *  @return self
 */
- (instancetype)initWithFontSize:(CGFloat)fontSize
                       textColor:(JHColor *)textColor
                            text:(NSString *)text
                     shadowStyle:(JHDanmakuShadowStyle)shadowStyle
                            font:(JHFont *)font
                           speed:(CGFloat)speed
                       direction:(JHScrollDanmakuDirection)direction;
- (CGFloat)speed;
- (JHScrollDanmakuDirection)direction;



/**
 计算当前窗口所能容纳的轨道数量
 
 @param contentRect 窗口大小
 @param danmakuSize 弹幕大小
 @return 当前窗口所能容纳的轨道数量
 */
- (NSInteger)channelCountWithContentRect:(CGRect)contentRect danmakuSize:(CGSize)danmakuSize;

/**
 计算当前轨道高度
 
 @param channelCount 轨道数量
 @param rect 窗口尺寸
 @return 当前轨道高度
 */
- (NSInteger)channelHeightWithChannelCount:(NSInteger)channelCount contentRect:(CGRect)rect;

/**
 *  计算弹幕所在轨道
 *
 *  @param frame         弹幕 frame
 *  @param channelHeight 轨道高
 *
 *  @return 轨道
 */
- (NSInteger)channelWithFrame:(CGRect)frame channelHeight:(CGFloat)channelHeight;
@end

