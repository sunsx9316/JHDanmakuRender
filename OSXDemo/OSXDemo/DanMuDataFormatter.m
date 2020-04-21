//
//  DanMuDataFormatter.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanMuDataFormatter.h"
#import "DanMuDataModel.h"
#import "JHFloatDanmaku.h"
#import "JHFloatDanmaku.h"
#import "JHDanmakuEngine+Tools.h"
#import "GDataXMLNode.h"

typedef void(^callBackBlock)(DanMuDataModel *model);
@implementation DanMuDataFormatter
+ (NSDictionary *)dicWithObj:(id)obj{
    NSMutableDictionary <NSNumber *,NSMutableArray <JHBaseDanmaku *> *> *dic = [NSMutableDictionary dictionary];
    
    NSFont *font = [NSFont systemFontOfSize:25];
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
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray <NSDictionary *>*comments = jsonDic[@"danmakuData"][@"comments"];
    
    [comments enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <NSString *>*datas = [obj[@"p"] componentsSeparatedByString:@","];
        DanMuDataModel* model = [[DanMuDataModel alloc] init];
        model.time = datas[0].doubleValue;
        model.mode = datas[1].integerValue;
        model.color = datas[2].integerValue;
        model.message = obj[@"m"];
        if (block) block(model);
    }];
    
}
@end

