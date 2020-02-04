//
//  JHDanmakuProtocol.h
//  Pods
//
//  Created by JimHuang on 2020/2/3.
//

#import "JHDanmakuDefinition.h"

#ifndef JHDanmakuProtocol_h
#define JHDanmakuProtocol_h

@class JHDanmakuEngine, JHDanmakuContainer, JHDanmakuContext;

@protocol JHDanmakuProtocol <NSObject>

typedef NS_ENUM(NSUInteger, JHDanmakuEffectStyle) {
    JHDanmakuEffectStyleUndefine = 0,
    //啥也没有
    JHDanmakuEffectStyleNone = 100,
    //描边
    JHDanmakuEffectStyleStroke,
    //投影
    JHDanmakuEffectStyleShadow,
    //模糊阴影
    JHDanmakuEffectStyleGlow,
};

@property (assign, nonatomic) NSTimeInterval appearTime;
@property (assign, nonatomic) NSTimeInterval disappearTime;
@property (strong, nonatomic) NSAttributedString *attributedString;
//当前所在轨道
@property (assign, nonatomic) NSInteger currentChannel;

/// 是否处于激活状态
/// @param time 当前时间
/// @param context 附加信息
- (BOOL)isActiveWithTime:(NSTimeInterval)time context:(JHDanmakuContext *)context;

/// 计算初始位置
/// @param context 附加信息
- (CGPoint)originalPositonWithContext:(JHDanmakuContext *)context;

@end


#endif /* JHDanmakuProtocol_h */
