//
//  JHDanmakuMethod.m
//  JHDanmakuRender
//
//  Created by JimHuang on 2018/5/1.
//

#import "JHDanmakuMethod.h"
#import "JHDanmakuDefinition.h"

JHColor *jh_RGBColor(int r, int g, int b) {
    return jh_RGBAColor(r, g, b, 1);
};

JHColor *jh_RGBAColor(int r, int g, int b, CGFloat a) {
#if JH_IOS
    return [JHColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
#else
    if (@available(macOS 10.9, *)) {
        return [JHColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
    }
    else {
        return [JHColor colorWithDeviceRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
    }
#endif
    
};

CGFloat jh_scale() {
#if JH_IOS
    return [UIScreen mainScreen].scale;
#else
    return [NSScreen mainScreen].backingScaleFactor;
#endif
    
};

CGFloat jh_colorBrightness(JHColor *color) {
#if JH_IOS
    CGFloat b;
    [color getHue:nil saturation:nil brightness:&b alpha:nil];
    return b;
#else
    return color.brightnessComponent;
#endif
};

@implementation JHDanmakuMethod

+ (NSShadow *)shadowWithColor:(JHColor *)color {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, -1);
    shadow.shadowColor = [self shadowColorWithColor:color];
    return shadow;
}

+ (JHColor *)shadowColorWithColor:(JHColor *)color {
    if (jh_colorBrightness(color) > 0.6) {
        return jh_RGBColor(0, 0, 0);
    }
    
    return jh_RGBColor(1, 1, 1);
}

+ (NSDictionary *)edgeEffectDicWithStyle:(JHDanmakuShadowStyle)style {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    switch (style) {
        case JHDanmakuShadowStyleGlow:
        {
            NSShadow *shadow = [JHDanmakuMethod shadowWithColor:textColor];
            shadow.shadowBlurRadius = 3;
            
            [str addAttributes:@{NSShadowAttributeName : shadow} range:range];
        }
            break;
        case JHDanmakuShadowStyleShadow:
        {
            [str addAttributes:@{NSShadowAttributeName : [JHDanmakuMethod shadowWithColor:textColor]} range:range];
        }
            break;
        case JHDanmakuShadowStyleStroke:
        {
            [str addAttributes:@{NSStrokeColorAttributeName : [JHDanmakuMethod shadowColorWithColor:textColor],
                                 NSStrokeWidthAttributeName : @-3} range:range];
        }
            break;
        default:
            break;
    }
}

@end

