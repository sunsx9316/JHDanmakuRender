//
//  DanMuDataFormatter.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuDataFormatter.h"
#import "DanMuDataModel.h"
#import "ScrollDanmaku.h"
#import "FloatDanmaku.h"
#import "JHDanmakuEngine+Tools.h"
#import "GDataXMLNode.h"

typedef void(^callBackBlock)(DanMuDataModel *model);
@implementation DanMuDataFormatter
+ (NSDictionary *)dicWithObj:(id)obj{
    NSMutableDictionary <NSNumber *,NSMutableArray <ParentDanmaku *> *> *dic = [NSMutableDictionary dictionary];
    
    NSFont *font = [NSFont systemFontOfSize:25];
    NSInteger danMufontSpecially = danmakuShadowStyleNone;
    [self danMuWithBilibiliData:obj block:^(DanMuDataModel *model) {
        NSInteger time = model.time;
        if (!dic[@(time)]) dic[@(time)] = [NSMutableArray array];
        ParentDanmaku *danmaku = [JHDanmakuEngine DanmakuWithText:model.message color:model.color spiritStyle:model.mode shadowStyle:danMufontSpecially fontSize: font.pointSize font:font];
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

