//
//  JHFloatDanmaku.m
//  JHDanmakuRenderDemo
//
//  Created by JimHuang on 16/2/22.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHFloatDanmaku.h"
#import "JHDanmakuContainer.h"
#import "JHBaseDanmaku+Private.h"

@interface JHFloatDanmaku()
@property (assign, nonatomic) CGFloat during;
@property (assign, nonatomic) JHFloatDanmakuDirection direction;
@end

@implementation JHFloatDanmaku
{
    NSInteger _currentChannel;
}

- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(JHColor *)textColor text:(NSString *)text shadowStyle:(JHDanmakuShadowStyle)shadowStyle font:(JHFont *)font during:(CGFloat)during direction:(JHFloatDanmakuDirection)direction{
    
    if (self = [super initWithFontSize:fontSize textColor:textColor text:text shadowStyle:shadowStyle font:font]) {
        _direction = direction;
        _during = during;
    }
    return self;
}

- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(JHDanmakuContainer *)container{
    return self.appearTime + _during >= time;
}

/**
 *  找出同方向的弹幕 按照所在轨道归类弹幕
 优先选择没有弹幕的轨道
 如果都有 选择弹幕最少的轨道
 *
 */
- (CGPoint)originalPositonWithEngine:(JHDanmakuEngine *)engine
                                rect:(CGRect)rect
                         danmakuSize:(CGSize)danmakuSize
                      timeDifference:(NSTimeInterval)timeDifference {
    NSInteger channelCount = (engine.channelCount == 0) ? [self channelCountWithContentRect:rect danmakuSize:danmakuSize] : engine.channelCount;
    NSDictionary <NSNumber *, NSNumber *>*dic = engine.channelDic[@(self.channelDirectionType)];
    
    //轨道高
    NSInteger channelHeight = rect.size.height / channelCount;
    
    __block NSInteger channel = channelCount - 1;
    //每条轨道都有弹幕
    if (dic.count >= channelCount) {
        //选择弹幕最少的轨道
        __block NSInteger minCount = dic.allValues.firstObject.integerValue;
        [dic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            if (minCount >= obj.integerValue) {
                minCount = obj.integerValue;
                channel = key.integerValue;
            }
        }];
    }
    //选择没有弹幕的轨道
    else {
        if (_direction == JHFloatDanmakuDirectionT2B) {
            for (NSInteger i = 0; i < channelCount; ++i) {
                if (!dic[@(i)]) {
                    channel = i;
                    break;
                }
            }
        }
        else {
            for (NSInteger i = channelCount - 1; i >= 0; --i) {
                if (!dic[@(i)]) {
                    channel = i;
                    break;
                }
            }
        }
    }
    
    _currentChannel = channel;
    return CGPointMake((rect.size.width - danmakuSize.width) / 2, channelHeight * channel);
}


- (CGFloat)during {
    return _during;
}

- (JHFloatDanmakuDirection)direction {
    return _direction;
}

- (NSInteger)currentChannel {
    return _currentChannel;
}

- (ChannelDirectionType)channelDirectionType {
    return ChannelDirectionTypeVertical;
}

#pragma mark - 私有方法
- (NSInteger)channelCountWithContentRect:(CGRect)contentRect danmakuSize:(CGSize)danmakuSize {
    NSInteger channelCount = contentRect.size.height / danmakuSize.height;
    return channelCount > 4 ? channelCount : 4;
}
@end
