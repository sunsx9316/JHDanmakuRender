//
//  DanMuDataFormatter.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuDataFormatter.h"
#import "DanMuDataModel.h"
#import "JHScrollDanmaku.h"
#import "JHFloatDanmaku.h"
#import "JHDanmakuEngine+Tools.h"
#import "GDataXMLNode.h"

typedef void(^callBackBlock)(DanMuDataModel *model);
@implementation DanMuDataFormatter
+ (NSDictionary *)dicWithObj:(id)obj{
    NSMutableDictionary <NSNumber *,NSMutableArray <JHBaseDanmaku *> *> *dic = [NSMutableDictionary dictionary];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSInteger danMufontSpecially = JHDanmakuEffectStyleNone;
    
    [self danMuWithBilibiliData:obj block:^(DanMuDataModel *model) {
        NSInteger time = model.time;
        if (!dic[@(time)]) dic[@(time)] = [NSMutableArray array];
        JHBaseDanmaku *danmaku = [JHDanmakuEngine DanmakuWithText:model.message color:model.color spiritStyle:model.mode shadowStyle:danMufontSpecially font:font];
        danmaku.appearTime = model.time;
        [dic[@(time)] addObject: danmaku];
    }];

    return dic;
}

#pragma mark - 私有方法

//b站解析方式
+ (void)danMuWithBilibiliData:(NSData*)data block:(callBackBlock)block{
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:data error:nil];
    GDataXMLElement *rootElement = document.rootElement;
    NSArray *array = [rootElement elementsForName:@"d"];
    for (GDataXMLElement *ele in array) {
            NSArray* strArr = [[[ele attributeForName:@"p"] stringValue] componentsSeparatedByString:@","];
            DanMuDataModel* model = [[DanMuDataModel alloc] init];
            model.time = [strArr[0] floatValue];
            model.mode = [strArr[1] intValue];
            model.color = [strArr[3] intValue];
            model.message = [ele stringValue];
            if (block) block(model);
    }
}
@end

