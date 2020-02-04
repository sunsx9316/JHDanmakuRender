//
//  JHScrollDanmaku.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHScrollDanmaku.h"
#import "JHDanmakuContainer.h"
#import "JHDanmakuEngine+Private.h"
#import "JHDanmakuContext.h"
//基础速度
static CGFloat kBasicSpeed = 100.0;
//默认弹幕长度 数值越大 整体速度越慢
static CGFloat kDefaultDanmakuWith = 1300;

NSString *JHScrollDanmakuExtraSpeedKey = @"extraSpeed";

@interface JHScrollDanmaku()
@property (assign, nonatomic) CGFloat speed;
@property (assign, nonatomic) JHScrollDanmakuDirection direction;
@property (nonatomic, assign) NSTimeInterval willDisappearTime;
@end


@implementation JHScrollDanmaku

- (instancetype)initWithFont:(JHFont *)font
                        text:(NSString *)text
                   textColor:(JHColor *)textColor
                 effectStyle:(JHDanmakuEffectStyle)effectStyle
                   direction:(JHScrollDanmakuDirection)direction {
    if (self = [super initWithFont:font text:text textColor:textColor effectStyle:effectStyle]) {
        _direction = direction;
    }
    return self;
}

- (BOOL)isActiveWithTime:(NSTimeInterval)time context:(JHDanmakuContext *)context {
    
    JHDanmakuEngine *engine = context.engine;
    CGRect windowFrame = engine.canvas.bounds;
    CGSize danmakuSize = context.danmakuSize;
    CGPoint point = context.originalPosition;
    CGFloat extraSpeed = [engine.userInfo[JHScrollDanmakuExtraSpeedKey] doubleValue] ?: 1;
    NSInteger realitySpeed = (_speed * extraSpeed);
    CGFloat timeDifference = time - self.appearTime;
    
    CGRect containerFrame = CGRectZero;
    containerFrame.size = danmakuSize;
    containerFrame.origin = point;
    
    switch (_direction) {
        case JHScrollDanmakuDirectionR2L:
        {
            point.x -= realitySpeed * timeDifference;
            containerFrame.origin = point;
            if (context.updateDanmakuPointCallBack) {
                context.updateDanmakuPointCallBack(point);
            }
            return CGRectGetMaxX(containerFrame) >= 0;
        }
        case JHScrollDanmakuDirectionL2R:
        {
            point.x += realitySpeed * timeDifference;
            containerFrame.origin = point;
            if (context.updateDanmakuPointCallBack) {
                context.updateDanmakuPointCallBack(point);
            }
            return CGRectGetMinX(containerFrame) <= windowFrame.size.width;
        }
        case JHScrollDanmakuDirectionB2T:
        {
            point.y -= realitySpeed * timeDifference;
            containerFrame.origin = point;
            if (context.updateDanmakuPointCallBack) {
                context.updateDanmakuPointCallBack(point);
            }
            return CGRectGetMaxY(containerFrame) >= 0;
        }
        case JHScrollDanmakuDirectionT2B:
        {
            point.y += realitySpeed * timeDifference;
            containerFrame.origin = point;
            if (context.updateDanmakuPointCallBack) {
                context.updateDanmakuPointCallBack(point);
            }
            return CGRectGetMinY(containerFrame) <= windowFrame.size.height;
        }
    }
    return NO;
}

- (CGPoint)originalPositonWithContext:(JHDanmakuContext *)context {
    NSMutableDictionary <NSNumber *, JHScrollDanmaku *>*dic = [NSMutableDictionary dictionary];
    
    JHDanmakuEngine *engine = context.engine;
    CGRect rect = engine.canvas.bounds;
    CGFloat extraSpeed = [engine.userInfo[JHScrollDanmakuExtraSpeedKey] doubleValue] ?: 1;
    CGSize danmakuSize = context.danmakuSize;
    CGFloat timeDifference = engine.currentTime - self.appearTime;
    NSInteger realitySpeed = 0;
    CGFloat start = 0;
    
    switch (_direction) {
        case JHScrollDanmakuDirectionR2L:
        case JHScrollDanmakuDirectionL2R: {
            _speed = ceil(kBasicSpeed + ((danmakuSize.width / kDefaultDanmakuWith) * kBasicSpeed));
            realitySpeed = (_speed * extraSpeed);
            if (_direction == JHScrollDanmakuDirectionR2L) {
                start = CGRectGetWidth(rect) - timeDifference * realitySpeed;
                self.willDisappearTime = self.appearTime + (start / realitySpeed);
            } else {
                CGFloat timeDifferenceOffset = timeDifference * realitySpeed;
                start = -danmakuSize.width + timeDifferenceOffset;
                self.willDisappearTime = self.appearTime + ((CGRectGetWidth(rect) - timeDifferenceOffset) / realitySpeed);
            }
            
            self.disappearTime = danmakuSize.width / realitySpeed + self.willDisappearTime;
        }
            break;
        case JHScrollDanmakuDirectionB2T:
        case JHScrollDanmakuDirectionT2B: {
            _speed = ceil(kBasicSpeed + ((danmakuSize.height / kDefaultDanmakuWith) * kBasicSpeed));
            realitySpeed = (_speed * extraSpeed);
            
            if (_direction == JHScrollDanmakuDirectionB2T) {
                start = CGRectGetHeight(rect) - timeDifference * realitySpeed;
                self.willDisappearTime = self.appearTime + (start / realitySpeed);
            } else {
                CGFloat timeDifferenceOffset = timeDifference * realitySpeed;
                start = -danmakuSize.height + timeDifferenceOffset;
                self.willDisappearTime = self.appearTime + ((CGRectGetHeight(rect) - timeDifferenceOffset) / realitySpeed);
            }
            
            self.disappearTime = danmakuSize.height / realitySpeed + self.willDisappearTime;
        }
            break;
    }
    
    NSInteger channelCount = (engine.channelCount == 0) ? [self channelCountWithContentRect:rect danmakuSize:danmakuSize] : engine.channelCount;
    NSArray <JHDanmakuContainer *>*activeContainer = engine.activeContainer;
    
    //轨道高
    NSInteger channelHeight = [self channelHeightWithChannelCount:channelCount contentRect:rect];
    
    [activeContainer enumerateObjectsUsingBlock:^(JHDanmakuContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.danmaku isKindOfClass:[self class]]) {
            JHScrollDanmaku *aDanmaku = (JHScrollDanmaku *)obj.danmaku;
            //同方向
            if (self.direction == aDanmaku.direction) {
                //计算弹幕所在轨道
                NSNumber *channel = @(aDanmaku.currentChannel);
                JHScrollDanmaku *oldDanmaku = dic[channel];
                if (oldDanmaku == nil) {
                    dic[channel] = aDanmaku;
                } else {
                    if (aDanmaku.disappearTime > oldDanmaku.disappearTime) {
                        dic[channel] = aDanmaku;
                    }
                }
            }
        }
    }];
    
    __block NSInteger channel = -1;

    for (NSInteger i = 0; i < channelCount; ++i) {
        
        NSNumber *key = @(i);
        JHScrollDanmaku *obj = dic[key];
        if (obj) {
            //弹幕正好完全显示的时间
            NSTimeInterval danmakuCompleteShowTime = obj.appearTime + (obj.disappearTime - obj.willDisappearTime);
            if (_willDisappearTime > obj.disappearTime && self.appearTime > danmakuCompleteShowTime) {
                channel = key.integerValue;
                break;
            }
        } else {
            channel = key.integerValue;
            break;
        }
    }
    
    if (channel == -1) {
        for (NSInteger i = 0; i < channelCount; ++i) {
            if (!dic[@(i)]) {
                channel = i;
                break;
            }
        }
        
        if (channel == -1) {
            channel = arc4random_uniform((u_int32_t)channelCount);
        }
    }
    
    self.currentChannel = channel;
    
    switch (_direction) {
        case JHScrollDanmakuDirectionR2L:
            return CGPointMake(start, channelHeight * channel);
        case JHScrollDanmakuDirectionL2R:
            return CGPointMake(start, channelHeight * channel);
        case JHScrollDanmakuDirectionB2T:
            return CGPointMake(channelHeight * channel, start);
        case JHScrollDanmakuDirectionT2B:
            return CGPointMake(channelHeight * channel, start);
    }
    
    return CGPointMake(rect.size.width, rect.size.height);
}

#pragma mark - 私有方法
- (NSInteger)channelCountWithContentRect:(CGRect)contentRect danmakuSize:(CGSize)danmakuSize {
    NSInteger channelCount = 0;
    if (_direction == JHScrollDanmakuDirectionL2R || _direction == JHScrollDanmakuDirectionR2L) {
        channelCount = CGRectGetHeight(contentRect) / danmakuSize.height;
        return channelCount > 4 ? channelCount : 4;
    }
    channelCount = CGRectGetWidth(contentRect) / danmakuSize.width;
    return channelCount > 4 ? channelCount : 4;
}

- (NSInteger)channelHeightWithChannelCount:(NSInteger)channelCount contentRect:(CGRect)rect {
    if (_direction == JHScrollDanmakuDirectionL2R || _direction == JHScrollDanmakuDirectionR2L) {
        return CGRectGetHeight(rect) / channelCount;
    }
    else {
        return CGRectGetWidth(rect) / channelCount;
    }
}

- (NSInteger)channelWithFrame:(CGRect)frame channelHeight:(CGFloat)channelHeight {
    if (_direction == JHScrollDanmakuDirectionL2R || _direction == JHScrollDanmakuDirectionR2L) {
        return CGRectGetMinY(frame) / channelHeight;
    }
    else {
        return CGRectGetMinX(frame) / channelHeight;
    }
}

@end

