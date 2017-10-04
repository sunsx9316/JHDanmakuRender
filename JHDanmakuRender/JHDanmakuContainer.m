//
//  JHDanmakuContainer.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuContainer.h"
#import "JHDanmakuEngine.h"

@implementation JHDanmakuContainer
{
    JHBaseDanmaku *_danmaku;
}

- (instancetype)initWithDanmaku:(JHBaseDanmaku *)danmaku {
    if (self = [super init]) {
#if !TARGET_OS_IPHONE
        self.editable = NO;
        self.drawsBackground = NO;
        self.bordered = NO;
#endif
        [self setWithDanmaku:danmaku];
    }
    return self;
}

- (id<CAAction>)actionForKey:(NSString *)event {
    return nil;
}

- (void)setWithDanmaku:(JHBaseDanmaku *)danmaku {
    _danmaku = danmaku;
    self.jh_attributedText = danmaku.attributedString;
    [self updateAttributed];
}

- (BOOL)updatePositionWithTime:(NSTimeInterval)time {
    return [_danmaku updatePositonWithTime:time container:self];
}

- (JHBaseDanmaku *)danmaku {
    return _danmaku;
}

- (void)setOriginalPosition:(CGPoint)originalPosition {
    _originalPosition = originalPosition;
    CGRect rect = self.frame;
    rect.origin = originalPosition;
    self.frame = rect;
}

- (void)updateAttributed {
    NSDictionary *globalAttributed = [self.danmakuEngine globalAttributedDic];
    JHFont *font = [self.danmakuEngine globalFont];
    JHDanmakuShadowStyle shadowStyle = [self.danmakuEngine globalShadowStyle];
    
    if (self.jh_attributedText.length) {
        NSMutableAttributedString *str = [self.jh_attributedText mutableCopy];
        NSRange range = NSMakeRange(0, str.length);
        
        if (globalAttributed) {
            [str addAttributes:globalAttributed range:range];
        }
        
        if (font) {
            [str addAttributes:@{NSFontAttributeName : font} range:range];
        }
        
        if (shadowStyle >= JHDanmakuShadowStyleNone) {
            JHColor *textColor = [self.jh_attributedText attributesAtIndex:0 effectiveRange:nil][NSForegroundColorAttributeName];
            [str removeAttribute:NSShadowAttributeName range:range];
            [str removeAttribute:NSStrokeColorAttributeName range:range];
            [str removeAttribute:NSStrokeWidthAttributeName range:range];
            
            switch (shadowStyle) {
                case JHDanmakuShadowStyleGlow:
                {
                    NSShadow *shadow = [self shadowWithTextColor:textColor];
                    shadow.shadowBlurRadius = 3;
                    [str addAttributes:@{NSShadowAttributeName : shadow} range:range];
                }
                    break;
                case JHDanmakuShadowStyleShadow:
                {
                    [str addAttributes:@{NSShadowAttributeName : [self shadowWithTextColor:textColor]} range:range];
                }
                    break;
                case JHDanmakuShadowStyleStroke:
                {
                    [str addAttributes:@{NSStrokeColorAttributeName : [self shadowColorWithTextColor:textColor],
                                         NSStrokeWidthAttributeName : @-3} range:range];
                }
                    break;
                default:
                    break;
            }
            
        }
        
        self.jh_attributedText = str;
    }
    
    [self sizeToFit];
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

