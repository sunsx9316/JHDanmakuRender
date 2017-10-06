//
//  abstractDanmaku.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHBaseDanmaku.h"
#import "JHDanmakuEngine+Private.h"

@implementation JHBaseDanmaku

- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(JHColor *)textColor text:(NSString *)text shadowStyle:(JHDanmakuShadowStyle)shadowStyle font:(JHFont *)font{
    if (self = [super init]) {
        //字体为空根据fontSize初始化
        if (!font) font = [JHFont systemFontOfSize: fontSize];
        if (!text) text = @"";
        if (!textColor) textColor = [JHColor blackColor];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = font;
        dic[NSForegroundColorAttributeName] = textColor;
        switch (shadowStyle) {
            case JHDanmakuShadowStyleGlow:
            {
                NSShadow *shadow = [self shadowWithTextColor:textColor];
                shadow.shadowBlurRadius = 3;
                dic[NSShadowAttributeName] = shadow;
            }
                break;
            case JHDanmakuShadowStyleShadow:
            {
                dic[NSShadowAttributeName] = [self shadowWithTextColor:textColor];
            }
                break;
            case JHDanmakuShadowStyleStroke:
            {
                dic[NSStrokeColorAttributeName] = [self shadowColorWithTextColor:textColor];
                dic[NSStrokeWidthAttributeName] = @-3;
            }
                break;
            default:
                break;
        }
        _font = font;
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    }
    return self;
}

- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(JHDanmakuContainer *)container {
    return NO;
}

- (CGPoint)originalPositonWithEngine:(JHDanmakuEngine *)engine
                                rect:(CGRect)rect
                         danmakuSize:(CGSize)danmakuSize
                      timeDifference:(NSTimeInterval)timeDifference {
    return CGPointZero;
}

- (NSString *)text {
    return _attributedString.string;
}

- (JHColor *)textColor {
    if (!_attributedString.length) return nil;
    
    return [_attributedString attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
}

- (NSAttributedString *)attributedString {
    return _attributedString;
}

#pragma mark - 私有方法

- (NSShadow *)shadowWithTextColor:(JHColor *)textColor {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, -1);
    shadow.shadowColor = [self shadowColorWithTextColor:textColor];
    return shadow;
}

- (JHColor *)shadowColorWithTextColor:(JHColor *)textColor {
    if (JHColorBrightness(textColor) > 0.5) {
        return [JHColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    return [JHColor colorWithRed:1 green:1 blue:1 alpha:1];
}

@end

