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
+ (JHBaseDanmaku *)DanmakuWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle shadowStyle:(JHDanmakuShadowStyle)shadowStyle fontSize:(CGFloat)fontSize font:(UIFont *)font{
    if (spiritStyle == 4 || spiritStyle == 5) {
        return [[JHFloatDanmaku alloc] initWithFontSize:fontSize textColor:[UIColor colorWithRGB:(uint32_t)color] text:text shadowStyle:shadowStyle font:font during:3 direction:spiritStyle == 4 ? JHFloatDanmakuDirectionB2T : JHFloatDanmakuDirectionT2B];
    }else{
        return [[JHScrollDanmaku alloc] initWithFontSize:fontSize textColor:[UIColor colorWithRGB:(uint32_t)color] text:text shadowStyle:shadowStyle font:font speed:arc4random()%100 + 50 direction:JHScrollDanmakuDirectionR2L];
    }
}

@end
