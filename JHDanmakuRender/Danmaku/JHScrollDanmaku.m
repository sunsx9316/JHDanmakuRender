//
//  JHScrollDanmaku.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHScrollDanmaku.h"
#import "JHDanmakuContainer.h"
#import "JHBaseDanmaku+Private.h"

//当前窗口大小
#if TARGET_OS_IPHONE
#define kWindowFrame [UIScreen mainScreen].bounds
#else
#define kWindowFrame NSApp.keyWindow.frame
#endif

@interface JHScrollDanmaku()
@property (assign, nonatomic) CGFloat speed;
@property (assign, nonatomic) JHScrollDanmakuDirection direction;
@end

@implementation JHScrollDanmaku
{
    NSInteger _currentChannel;
}

- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(JHColor *)textColor text:(NSString *)text shadowStyle:(JHDanmakuShadowStyle)shadowStyle font:(JHFont *)font speed:(CGFloat)speed direction:(JHScrollDanmakuDirection)direction {
    if (self = [super initWithFontSize:fontSize textColor:textColor text:text shadowStyle:shadowStyle font:font]) {
        _speed = speed;
        _direction = direction;
    }
    return self;
}

- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(JHDanmakuContainer *)container{
    CGRect windowFrame = kWindowFrame;
    CGRect containerFrame = container.frame;
    CGPoint point = container.originalPosition;
    
    switch (_direction) {
        case JHScrollDanmakuDirectionR2L:
        {
            point.x -= (_speed * self.extraSpeed) * (time - self.appearTime);
            containerFrame.origin = point;
            container.frame = containerFrame;
            return containerFrame.origin.x + containerFrame.size.width >= 0;
        }
        case JHScrollDanmakuDirectionL2R:
        {
            point.x += (_speed * self.extraSpeed) * (time - self.appearTime);
            containerFrame.origin = point;
            container.frame = containerFrame;
            return containerFrame.origin.x <= windowFrame.size.width;
        }
        case JHScrollDanmakuDirectionB2T:
        {
            point.y -= (_speed * self.extraSpeed) * (time - self.appearTime);
            containerFrame.origin = point;
            container.frame = containerFrame;
            return CGRectGetMaxY(containerFrame) >= 0;
        }
        case JHScrollDanmakuDirectionT2B:
        {
            point.y += (_speed * self.extraSpeed) * (time - self.appearTime);
            containerFrame.origin = point;
            container.frame = containerFrame;
            return containerFrame.origin.y <= windowFrame.size.height;
        }
    }
    return NO;
}

/**
 *
 遍历所有同方向的弹幕
 如果方向是左右或者右左 channelHeight = 窗口高/channelCount
 如果是上下或者下上 channelHeight = 窗口宽/channelCount
 左右方向按照y/channelHeight 归类
 上下方向按照x/channelHeight 归类
 优先选择没有弹幕的轨道
 如果都有 计算选择弹幕最少的轨道 如果所有轨道弹幕数相同 则随机选择一条
 */
- (CGPoint)originalPositonWithEngine:(JHDanmakuEngine *)engine
                                rect:(CGRect)rect
                         danmakuSize:(CGSize)danmakuSize
                      timeDifference:(NSTimeInterval)timeDifference {
    NSInteger channelCount = (engine.channelCount == 0) ? [self channelCountWithContentRect:rect danmakuSize:danmakuSize] : engine.channelCount;
    NSDictionary <NSNumber *, NSNumber *>*dic = engine.channelDic[@(self.channelDirectionType)];
    
    //轨道高
    NSInteger channelHeight = [self channelHeightWithChannelCount:channelCount contentRect:rect];
    
    __block NSInteger channel = channelCount - 1;
    
    if (dic.count >= channelCount) {
        __block NSUInteger minCount = dic.allValues.firstObject.integerValue;
        __block BOOL isChange = NO;
        //选择弹幕最少的轨道
        [dic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            if (minCount >= obj.integerValue) {
                minCount = obj.integerValue;
                channel = key.integerValue;
                isChange = YES;
            }
        }];
        //没法发生交换 说明轨道弹幕数都一样 随机选取一个轨道
        if (!isChange) {
            channel = arc4random_uniform((u_int32_t)channelCount);
        }
    }
    else {
        for (NSInteger i = 0; i < channelCount; ++i) {
            if (!dic[@(i)]) {
                channel = i;
                break;
            }
        }
    }
    
    _currentChannel = channel;
    
    switch (_direction) {
        case JHScrollDanmakuDirectionR2L:
            return CGPointMake(rect.size.width - timeDifference * (_speed * self.extraSpeed), channelHeight * channel);
        case JHScrollDanmakuDirectionL2R:
            return CGPointMake(-danmakuSize.width + timeDifference * (_speed * self.extraSpeed), channelHeight * channel);
        case JHScrollDanmakuDirectionB2T:
            return CGPointMake(channelHeight * channel, rect.size.height - timeDifference * (_speed * self.extraSpeed));
        case JHScrollDanmakuDirectionT2B:
            return CGPointMake(channelHeight * channel, -danmakuSize.height + timeDifference * (_speed * self.extraSpeed));
    }
    return CGPointMake(rect.size.width, rect.size.height);
}

- (CGFloat)speed {
    return _speed;
}

- (JHScrollDanmakuDirection)direction {
    return _direction;
}

- (NSInteger)currentChannel {
    return _currentChannel;
}

- (ChannelDirectionType)channelDirectionType {
    if (_direction == JHScrollDanmakuDirectionR2L || _direction == JHScrollDanmakuDirectionL2R) {
        return ChannelDirectionTypeHorizontal;
    }
    
    return ChannelDirectionTypeVertical;
}

#pragma mark - 私有方法
- (NSInteger)channelCountWithContentRect:(CGRect)contentRect danmakuSize:(CGSize)danmakuSize {
    NSInteger channelCount = 0;
    if (_direction == JHScrollDanmakuDirectionL2R || _direction == JHScrollDanmakuDirectionR2L) {
        channelCount = contentRect.size.height / danmakuSize.height;
        return channelCount > 4 ? channelCount : 4;
    }
    channelCount = contentRect.size.width / danmakuSize.width;
    return channelCount > 4 ? channelCount : 4;
}

- (NSInteger)channelHeightWithChannelCount:(NSInteger)channelCount contentRect:(CGRect)rect {
    if (_direction == JHScrollDanmakuDirectionL2R || _direction == JHScrollDanmakuDirectionR2L) {
        return rect.size.height / channelCount;
    }
    else {
        return rect.size.width / channelCount;
    }
}

/**
 *  计算轨道
 *
 *  @param frame         弹幕 frame
 *  @param channelHeight 轨道高
 *
 *  @return 轨道
 */
- (NSInteger)channelWithFrame:(CGRect)frame channelHeight:(CGFloat)channelHeight {
    if (_direction == JHScrollDanmakuDirectionL2R || _direction == JHScrollDanmakuDirectionR2L) {
        return frame.origin.y / channelHeight;
    }else{
        return frame.origin.x / channelHeight;
    }
}

@end
