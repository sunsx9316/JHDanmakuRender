//
//  DanMuDataFormatter.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//  把弹幕数组转成字典的工具类
//
#import "JHDanmakuEngine.h"

@class ParentDanmaku;

@interface DanMuDataFormatter : NSObject
/**
 *  把对象转成时间字典
 *
 *  @param obj   对象b站是NSData
 *
 *  @return 时间字典
 */
+ (NSDictionary *)dicWithObj:(id)obj;
@end