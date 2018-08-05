//
//  JHDanmakuDefinition.h
//  OSXDemo
//
//  Created by JimHuang on 16/6/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHDanmakuEffectStyle) {
    JHDanmakuEffectStyleUndefine = 0,
    //啥也没有
    JHDanmakuEffectStyleNone = 100,
    //描边
    JHDanmakuEffectStyleStroke,
    //投影
    JHDanmakuEffectStyleShadow,
    //模糊阴影
    JHDanmakuEffectStyleGlow,
};

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

#define JH_IOS 1

typedef UIColor JHColor;
typedef UIFont JHFont;
typedef UIView JHView;
typedef UILabel JHLabel;

#define jh_attributedText attributedText
#define jh_text text

#define DANMAKU_MAX_CACHE_COUNT 20

#else
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#define JH_MAC_OS 1

typedef NSColor JHColor;
typedef NSFont JHFont;
typedef NSView JHView;
typedef NSTextField JHLabel;

#define jh_attributedText attributedStringValue
#define jh_text stringValue

#define DANMAKU_MAX_CACHE_COUNT 80

#endif

