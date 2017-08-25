//
//  JHDanmakuEngine+Private.h
//  OSXDemo
//
//  Created by JimHuang on 2017/8/25.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "JHDanmakuEngine.h"

typedef NS_ENUM(NSUInteger, ChannelDirectionType) {
    ChannelDirectionTypeHorizontal,
    ChannelDirectionTypeVertical,
};

@interface JHDanmakuEngine (Private)
@property (strong, nonatomic, readonly) NSDictionary<NSNumber *,NSMutableDictionary<NSNumber *,NSNumber *> *> *channelDic;
@end
