//
//  JHDanmakuEngine+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHDanmakuEngine.h"
#import "JHBaseDanmaku.h"

@interface JHDanmakuEngine (Tools)
+ (JHBaseDanmaku *)DanmakuWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle shadowStyle:(JHDanmakuEffectStyle)shadowStyle font:(NSFont *)font;
@end
