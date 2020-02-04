//
//  abstractDanmaku.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHBaseDanmaku.h"
#import "JHDanmakuEngine+Private.h"
#import "JHDanmakuPrivateHeader.h"

@implementation JHBaseDanmaku

@synthesize appearTime = _appearTime;
@synthesize disappearTime = _disappearTime;
@synthesize attributedString = _attributedString;
@synthesize currentChannel = _currentChannel;

- (instancetype)initWithFont:(JHFont *)font
                        text:(NSString *)text
                   textColor:(JHColor *)textColor
                 effectStyle:(JHDanmakuEffectStyle)effectStyle {
    if (self = [super init]) {
        //字体为空根据fontSize初始化
        if (!font) font = [JHFont systemFontOfSize: 15];
        if (!text) text = @"";
        if (!textColor) textColor = [JHColor blackColor];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = font;
        dic[NSForegroundColorAttributeName] = textColor;

        [dic addEntriesFromDictionary:[JHDanmakuMethod edgeEffectDicWithStyle:effectStyle textColor:textColor]];
        
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFont:nil text:nil textColor:nil effectStyle:JHDanmakuEffectStyleNone];
}

- (BOOL)isActiveWithTime:(NSTimeInterval)time context:(JHDanmakuContext *)context {
    return NO;
}

- (CGPoint)originalPositonWithContext:(JHDanmakuContext *)context {
    return CGPointZero;
}

@end

