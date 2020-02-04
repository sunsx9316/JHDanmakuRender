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
    self.aEngine.canvas.layoutStyle = JHDanmakuCanvasLayoutStyleWhenSizeChanged;
    self.aEngine.globalEffectStyle = JHDanmakuEffectStyleGlow;
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
    [self.aEngine setUserInfoWithKey:JHScrollDanmakuExtraSpeedKey value:@(sender.doubleValue)];
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
        NSString *title = [self.danmakuDirectionPopUpButton titleOfSelectedItem];
        JHScrollDanmakuDirection d = JHScrollDanmakuDirectionR2L;
        if ([title isEqualToString:@"从左到右"]) {
            d = JHScrollDanmakuDirectionL2R;
        }
        else if ([title isEqualToString:@"从上到下"]) {
            d = JHScrollDanmakuDirectionT2B;
        }
        else if ([title isEqualToString:@"从下到上"]) {
            d = JHScrollDanmakuDirectionB2T;
        }
        
        [self.aEngine sendDanmaku:[self scrollDanmakuWithFontSize:self.fontSizeSlider.floatValue textColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:1] text:@"滚动弹幕" direction:d]];
    }
    else {
        NSString *title = [self.danmakuDirectionPopUpButton titleOfSelectedItem];
        JHFloatDanmakuPosition direction = JHFloatDanmakuPositionAtBottom;
        if ([title isEqualToString:@"顶部弹幕"]) {
            direction = JHFloatDanmakuPositionAtTop;
        }
        
        [self.aEngine sendDanmaku:[self floatDanmakuWithFontSize:self.fontSizeSlider.floatValue textColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:1] text:@"浮动弹幕" direction:direction]];
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
- (JHFloatDanmaku *)floatDanmakuWithFontSize:(CGFloat)fontSize textColor:(NSColor *)textColor text:(NSString *)text direction:(JHFloatDanmakuPosition)direction {
    return [[JHFloatDanmaku alloc] initWithFont:[NSFont systemFontOfSize:fontSize] text:text textColor:textColor effectStyle:JHDanmakuEffectStyleGlow during:3 position:direction];
}
//初始化一个滚动弹幕
- (JHScrollDanmaku *)scrollDanmakuWithFontSize:(CGFloat)fontSize textColor:(NSColor *)textColor text:(NSString *)text direction:(JHScrollDanmakuDirection)direction {
    return [[JHScrollDanmaku alloc] initWithFont:[NSFont systemFontOfSize:fontSize] text:text textColor:textColor effectStyle:JHDanmakuEffectStyleGlow direction:direction];
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
		_scrollDanmakuDirectionArr = @[@"从右到左", @"从左到右", @"从下到上", @"从上到下"];
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
