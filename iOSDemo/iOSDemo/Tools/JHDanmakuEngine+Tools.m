//
//  JHDanmakuEngine+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuEngine+Tools.h"
#import "JHFloatDanmaku.h"
#import "JHScrollDanmaku.h"
#import "UIColor+Tools.h"

@implementation JHDanmakuEngine (Tools)
+ (JHBaseDanmaku *)DanmakuWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle shadowStyle:(JHDanmakuEffectStyle)shadowStyle font:(UIFont *)font {
    UIColor *_color = [UIColor colorWithRGB:(uint32_t)color];
    
    if (spiritStyle == 4 || spiritStyle == 5) {
        return [[JHFloatDanmaku alloc] initWithFont:font text:text textColor:_color effectStyle:shadowStyle during:3 position:spiritStyle == 4 ? JHFloatDanmakuPositionAtBottom : JHFloatDanmakuPositionAtTop];
    }
    else {
        return [[JHScrollDanmaku alloc] initWithFont:font text:text textColor:_color effectStyle:shadowStyle direction:JHScrollDanmakuDirectionR2L];
    }
}

@end
