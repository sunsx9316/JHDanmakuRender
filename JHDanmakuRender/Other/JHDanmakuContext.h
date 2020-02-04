//
//  JHDanmakuContext.h
//  JHDanmakuRender
//
//  Created by JimHuang on 2020/2/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHDanmakuContainer, JHDanmakuEngine;

@interface JHDanmakuContext : NSObject

/// 弹幕初始位置
@property (nonatomic, assign) CGPoint originalPosition;

/// 弹幕尺寸
@property (nonatomic, assign) CGSize danmakuSize;

@property (nonatomic, weak) JHDanmakuEngine *engine;

@property (nonatomic, copy) void(^updateDanmakuPointCallBack)(CGPoint point);

@end

NS_ASSUME_NONNULL_END
