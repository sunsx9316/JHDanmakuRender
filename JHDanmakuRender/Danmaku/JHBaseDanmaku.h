//
//  abstractDanmaku.h
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

 
#import <Foundation/Foundation.h>
#import "JHDanmakuProtocol.h"

@class JHDanmakuContainer, JHDanmakuEngine;
NS_ASSUME_NONNULL_BEGIN
@interface JHBaseDanmaku : NSObject<JHDanmakuProtocol>

- (instancetype)initWithFont:(JHFont *)font
                        text:(NSString *)text
                   textColor:(JHColor *)textColor
                 effectStyle:(JHDanmakuEffectStyle)effectStyle NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END
