//
//  JHDanmakuContainer.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuContainer.h"
#import "JHDanmakuEngine.h"
#import "JHDanmakuPrivateHeader.h"
#import "JHDanmakuContext.h"

@interface JHDanmakuContainer ()
@property (nonatomic, strong) JHDanmakuContext *context;
@end

@implementation JHDanmakuContainer

- (instancetype)initWithDanmaku:(id<JHDanmakuProtocol>)danmaku engine:(JHDanmakuEngine *)engine {
    if (self = [super init]) {
        _danmakuEngine = engine;
        self.context.engine = _danmakuEngine;
#if JH_MACOS
        self.editable = NO;
        self.drawsBackground = NO;
        self.bordered = NO;
#endif
        self.font = nil;
        self.textColor = nil;
        self.danmaku = danmaku;
    }
    return self;
}

- (id<CAAction>)actionForKey:(NSString *)event {
    return nil;
}

- (void)setDanmaku:(id<JHDanmakuProtocol>)danmaku {
    _danmaku = danmaku;
    self.attributedString = danmaku.attributedString;
    [self updateAttributedByGlobalStyle];
    [self resetPosition];
}

- (BOOL)updatePositionWithTime:(NSTimeInterval)time {
    return [_danmaku isActiveWithTime:time context:self.context];
}

- (void)updateAttributedByGlobalStyle {
    NSDictionary *globalAttributed = [self.danmakuEngine globalAttributedDic];
    JHFont *font = [self.danmakuEngine globalFont];
    JHDanmakuEffectStyle shadowStyle = [self.danmakuEngine globalEffectStyle];
    
    BOOL hasGlobalAttributed = (globalAttributed || font || (shadowStyle > JHDanmakuEffectStyleUndefine));
    
    if (self.attributedString.length && hasGlobalAttributed) {
        NSMutableAttributedString *str = [self.attributedString mutableCopy];
        NSRange range = NSMakeRange(0, str.length);
        
        if (globalAttributed) {
            [str addAttributes:globalAttributed range:range];
        }
        
        if (font) {
            [str addAttributes:@{NSFontAttributeName : font} range:range];
        }
        
        if (shadowStyle > JHDanmakuEffectStyleUndefine) {
            JHColor *textColor = [self.attributedString attributesAtIndex:0 effectiveRange:nil][NSForegroundColorAttributeName];
            [str removeAttribute:NSShadowAttributeName range:range];
            [str removeAttribute:NSStrokeColorAttributeName range:range];
            [str removeAttribute:NSStrokeWidthAttributeName range:range];
            
            [str addAttributes:[JHDanmakuMethod edgeEffectDicWithStyle:shadowStyle textColor:textColor] range:range];
            
        }
        
        self.attributedString = str;
    }
    
    
    CGRect frame = self.frame;
    
#if JH_MACOS
    frame.size = self.fittingSize;
#else
    frame.size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
#endif
    self.frame = frame;
    self.context.danmakuSize = frame.size;
}

- (void)resetPosition {
    CGPoint point = [_danmaku originalPositonWithContext:self.context];
    self.context.originalPosition = point;
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (void)removeFromCanvas {
    [self removeFromSuperview];
}

#pragma mark - 懒加载
- (JHDanmakuContext *)context {
    if (_context == nil) {
        _context = [[JHDanmakuContext alloc] init];
        __weak typeof(self)weakSelf = self;
        _context.updateDanmakuPointCallBack = ^(CGPoint point) {
            __strong typeof(weakSelf)self = weakSelf;
            if (!self) {
                return;
            }
            
            CGRect frame = self.frame;
            frame.origin = point;
            self.frame = frame;
        };
    }
    return _context;
}

@end


