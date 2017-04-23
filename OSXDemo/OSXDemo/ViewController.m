//
//  ViewController.m
//  OSXDemo
//
//  Created by JimHuang on 16/3/7.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ViewController.h"
#import "JHDanmakuRender.h"
#import "DanMuDataFormatter.h"

@interface ViewController()<JHDanmakuEngineDelegate>
@property (strong, nonatomic) JHDanmakuEngine *aEngine;
@property (weak) IBOutlet NSView *danmakuHoldView;
@property (weak) IBOutlet NSPopUpButton *danmakuTypePopUpButton;
@property (weak) IBOutlet NSPopUpButton *danmakuDirectionPopUpButton;
@property (weak) IBOutlet NSSlider *fontSizeSlider;
@property (weak) IBOutlet NSTextField *timeOffsetLabel;
@property (strong, nonatomic) NSArray *floatDanmakuDirectionArr;
@property (strong, nonatomic) NSArray *scrollDanmakuDirectionArr;
@property (strong, nonatomic) NSDictionary *danmakuDic;
@end

@implementation ViewController
{
    BOOL _loadTestDanmakus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.danmakuHoldView setWantsLayer:YES];
    [self.danmakuHoldView.layer setBackgroundColor:[NSColor lightGrayColor].CGColor];
    [self.danmakuDirectionPopUpButton addItemsWithTitles:self.scrollDanmakuDirectionArr];
    [self.danmakuHoldView addSubview: self.aEngine.canvas];
    //需要设置画布尺寸
    self.aEngine.canvas.frame = self.danmakuHoldView.bounds;

}

- (IBAction)clickDanmakuTypeButton:(NSPopUpButton *)sender {
    [self.danmakuDirectionPopUpButton removeAllItems];
    if (sender.indexOfSelectedItem == 1) {
        [self.danmakuDirectionPopUpButton addItemsWithTitles:self.floatDanmakuDirectionArr];
    }else{
        [self.danmakuDirectionPopUpButton addItemsWithTitles:self.scrollDanmakuDirectionArr];
    }
}

- (IBAction)clickSpeedSlider:(NSSlider *)sender {
    [self.aEngine setSpeed:sender.floatValue];
}

- (IBAction)clickFontSizeSlider:(NSSlider *)sender {
    NSFont *font = [NSFont systemFontOfSize:sender.floatValue];
    [self.aEngine setGlobalFont:font];
}

- (IBAction)clickDanmakuEdgeSlider:(NSSlider *)sender {
    self.aEngine.channelCount = sender.integerValue;
}
//发射弹幕
- (IBAction)clickLaunchDanmakuButton:(NSButton *)sender {
    if ([self.danmakuTypePopUpButton indexOfSelectedItem] == 0) {
        [self.aEngine sendDanmaku:[self scrollDanmakuWithFontSize:self.fontSizeSlider.floatValue textColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:1] text:@"滚动弹幕" direction:[self.danmakuDirectionPopUpButton indexOfSelectedItem] + 10 speed:arc4random_uniform(100) + 50]];
    }else{
        [self.aEngine sendDanmaku:[self floatDanmakuWithFontSize:self.fontSizeSlider.floatValue textColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:1] text:@"浮动弹幕" direction:[self.danmakuDirectionPopUpButton indexOfSelectedItem] + 100]];
    }
}

- (IBAction)clickStopButton:(NSButton *)sender {
    [self.aEngine stop];
}

- (IBAction)clickStartButton:(NSButton *)sender {
    [self.aEngine start];
}

- (IBAction)clickSuspandButton:(NSButton *)sender {
    [self.aEngine pause];
}

- (IBAction)clickTimeStepper:(NSStepper *)sender {
    self.timeOffsetLabel.stringValue = [NSString stringWithFormat:@"偏移: %d秒", sender.intValue];
    
    self.aEngine.offsetTime = sender.floatValue;
}

- (IBAction)clickLoadTestDanmakuButton:(NSButton *)sender {
//    [self.aEngine sendAllDanmakusDic:self.DanmakuDic];
//    //开启回退功能必须设置为yes
//    self.aEngine.turnonBackFunction = YES;
    _loadTestDanmakus = YES;
    [self.aEngine start];
    
}

#pragma mark - JHDanmakuEngineDelegate
- (NSArray <JHBaseDanmaku*>*)danmakuEngine:(JHDanmakuEngine *)danmakuEngine didSendDanmakuAtTime:(NSUInteger)time {
    if (_loadTestDanmakus) {
        return self.danmakuDic[@(time)];
    }
    return nil;
}

#pragma mark - 私有方法
//初始化一个浮动弹幕
- (JHFloatDanmaku *)floatDanmakuWithFontSize:(CGFloat)fontSize textColor:(NSColor *)textColor text:(NSString *)text direction:(JHFloatDanmakuDirection)direction{
    return [[JHFloatDanmaku alloc] initWithFontSize:fontSize textColor:textColor text:text shadowStyle:JHDanmakuShadowStyleGlow font:nil during:3 direction:direction];
}
//初始化一个滚动弹幕
- (JHScrollDanmaku *)scrollDanmakuWithFontSize:(CGFloat)fontSize textColor:(NSColor *)textColor text:(NSString *)text direction:(JHScrollDanmakuDirection)direction speed:(CGFloat)speed{
    return [[JHScrollDanmaku alloc] initWithFontSize:fontSize textColor:textColor text:text shadowStyle:JHDanmakuShadowStyleGlow font:nil speed:speed direction:direction];
}

#pragma mark - 懒加载
- (JHDanmakuEngine *)aEngine {
	if(_aEngine == nil) {
		_aEngine = [[JHDanmakuEngine alloc] init];
        _aEngine.canvas.layoutStyle = JHDanmakuCanvasLayoutStyleWhenSizeChanged;
        _aEngine.delegate = self;
	}
	return _aEngine;
}

- (NSArray *)floatDanmakuDirectionArr {
	if(_floatDanmakuDirectionArr == nil) {
		_floatDanmakuDirectionArr = @[@"顶部弹幕", @"底部弹幕"];
	}
	return _floatDanmakuDirectionArr;
}

- (NSArray *)scrollDanmakuDirectionArr {
	if(_scrollDanmakuDirectionArr == nil) {
		_scrollDanmakuDirectionArr = @[@"从右到左", @"从左到右", @"从上到下", @"从下到上"];
	}
	return _scrollDanmakuDirectionArr;
}

- (NSDictionary *)danmakuDic {
	if(_danmakuDic == nil) {
		_danmakuDic = [DanMuDataFormatter dicWithObj:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"]]];
	}
	return _danmakuDic;
}

@end
