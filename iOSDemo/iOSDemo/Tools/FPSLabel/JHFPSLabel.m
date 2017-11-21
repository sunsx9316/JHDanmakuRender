//
//  JHFPSLabel.m
//  iOSDemo
//
//  Created by Developer2 on 2017/11/15.
//  Copyright © 2017年 jim. All rights reserved.
//

#import "JHFPSLabel.h"
#import "JHDisplayLink.h"
#import "JHDanmakuMacroDefinition.h"

@interface JHFPSLabel ()<JHDisplayLinkDelegate>
@property (nonatomic, strong) JHDisplayLink *displayLink;
@property (nonatomic, strong) JHLabel *label;
@end

@implementation JHFPSLabel
{
    NSTimeInterval _lastTime;
    NSUInteger _count;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
        CGRect aFrame = self.label.frame;
        aFrame.size = frame.size;
        self.label.frame = aFrame;
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

#if !TARGET_OS_IPHONE
- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
    [super resizeSubviewsWithOldSize:oldSize];
    CGRect frame = self.label.frame;
    frame.size = self.frame.size;
    self.label.frame = frame;
}
#else
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.label.frame;
    frame.size = self.frame.size;
    self.label.frame = frame;
}
#endif

- (void)showFPS {
    [self.displayLink start];
}

#pragma mark - JHDisplayLinkDelegate
- (void)displayLinkDidCallbackWithTimestamp:(NSTimeInterval)timestamp {
    
#if !TARGET_OS_IPHONE
    timestamp /= 1000000000;
#endif
    
    if (_lastTime == 0) {
        _lastTime = timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = timestamp - _lastTime;
    if (delta < 0.5) {
        return;
    }
    _lastTime = timestamp;
    float fps = _count / delta;
    _count = 0;
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    self.label.jh_text = text;
}

#pragma mark - 懒加载
- (JHDisplayLink *)displayLink {
    if (_displayLink == nil) {
        _displayLink = [[JHDisplayLink alloc] init];
        _displayLink.delegate = self;
    }
    return _displayLink;
}


- (JHLabel *)label {
    if (_label == nil) {
        _label = [[JHLabel alloc] init];
        _label.font = [JHFont systemFontOfSize:15];
        _label.jh_text = @"0 FPS";
    }
    return _label;
}

@end
