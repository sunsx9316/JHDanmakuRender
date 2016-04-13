# JHDanmakuRender

一个ios和osx通用的弹幕渲染引擎


## 介绍
因为对功能的需要 最终还是自己动手写了这个弹幕引擎 部分源码参考了[BarrageRenderer](https://github.com/unash/BarrageRenderer) 和[Bilibili Mac Client](https://github.com/typcn/bilibili-mac-client) 

demo基本涵盖了常用的功能 需要的看demo就行

* 支持全局的字体样式更改
* 支持实时回退功能
* 更简单的api
* 支持ios、osx系统

## 简单使用
```
#import "JHDanmakuRender.h"
```
初始化一个滚动弹幕：
```
ScrollDanmaku *sc = [[ScrollDanmaku alloc] initWithFontSize:20 textColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] text:@"text" shadowStyle:danmakuShadowStyleGlow font:nil speed:arc4random_uniform(100) + 50 direction:scrollDanmakuDirectionR2L]
```
发射弹幕
```
[self.aEngine addDanmaku: sc]
```

## 截图
![osx](https://github.com/sunsx9316/JHDanmakuRender/blob/master/snapshot/osx.gif)
![ios](https://github.com/sunsx9316/JHDanmakuRender/blob/master/snapshot/ios.gif)

## 许可证
软件遵循MIT协议 详情请见LICENSE文件