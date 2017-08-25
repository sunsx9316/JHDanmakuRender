//
//  ViewController.m
//  IOSDemo
//
//  Created by JimHuang on 16/3/7.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "ViewController.h"
#import "JHDanmakuRender.h"
#import "DanMuDataFormatter.h"

@interface ViewController ()<UIAlertViewDelegate, JHDanmakuEngineDelegate>
@property (weak, nonatomic) IBOutlet UILabel *danmakuTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *danmakuDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOffsetLabel;
@property (weak, nonatomic) IBOutlet UIView *danmakuHoldView;
@property (strong, nonatomic) JHDanmakuEngine *aEngine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *showMenuButton;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (assign, nonatomic, getter=isMenuShow) BOOL menuShow;
@property (strong, nonatomic) NSArray *scrollDanmakuDirection;
@property (strong, nonatomic) NSArray *floatDanmakuDirection;
@property (strong, nonatomic) NSDictionary *danmakuDic;
@end

@implementation ViewController
{
    BOOL _loadTestDanmakus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.danmakuHoldView addSubview:self.aEngine.canvas];
    //需要设置画布尺寸
    self.aEngine.canvas.frame = self.danmakuHoldView.bounds;
    [self hideMenu];
}

- (IBAction)touchShowMenuButton:(UIButton *)sender {
    if (self.isMenuShow) {
        [self hideMenu];
    }else{
        [self showMenu];
    }
    
}

- (IBAction)touchSpeedButton:(UISlider *)sender {
    [self.aEngine setSpeed:sender.value];
}

- (IBAction)touchFontSizeButton:(UISlider *)sender {
    [self.aEngine setGlobalFont:[UIFont systemFontOfSize:sender.value]];
}

- (IBAction)touchDanmakuEdgeButton:(UISlider *)sender {
    self.aEngine.channelCount = sender.value;
}

- (IBAction)touchDanmakuTypeButton:(UIButton *)sender {
    [[[UIAlertView alloc] initWithTitle:@"弹幕类型" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"滚动弹幕",@"浮动弹幕", nil] show];
}

- (IBAction)touchDanmakuDirectionButton:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"弹幕方向" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    
    if ([self.danmakuTypeLabel.text isEqualToString:@"滚动弹幕"]) {
        for (NSString *str in self.scrollDanmakuDirection) {
            [alertView addButtonWithTitle:str];
        }
    }else if([self.danmakuTypeLabel.text isEqualToString:@"浮动弹幕"]){
        for (NSString *str in self.floatDanmakuDirection) {
            [alertView addButtonWithTitle:str];
        }
    }
    [alertView show];
}

- (IBAction)touchTimeOffsetStepper:(UIStepper *)sender {
    self.aEngine.offsetTime = sender.value;
    self.timeOffsetLabel.text = [NSString stringWithFormat:@"偏移: %d秒", (int)sender.value];
}

- (IBAction)touchTestDanmakuButton:(UIButton *)sender {
    _loadTestDanmakus = YES;
    [self.aEngine start];
}

- (IBAction)touchStopButton:(UIButton *)sender {
    [self.aEngine stop];
}

- (IBAction)touchStartButton:(UIButton *)sender {
    [self.aEngine start];
}

- (IBAction)touchSuspandButton:(UIButton *)sender {
    [self.aEngine pause];
}
//发射弹幕
- (IBAction)touchLaunchDanmakuButton:(UIButton *)sender {
    if ([self.danmakuTypeLabel.text isEqualToString:@"滚动弹幕"]) {
        NSString *str = self.danmakuDirectionLabel.text;
        JHScrollDanmakuDirection dir = JHScrollDanmakuDirectionB2T;
        if ([str isEqualToString:@"右->左"]) {
            dir = JHScrollDanmakuDirectionR2L;
        }else if ([str isEqualToString:@"左->右"]){
            dir = JHScrollDanmakuDirectionL2R;
        }else if ([str isEqualToString:@"上->下"]){
            dir = JHScrollDanmakuDirectionT2B;
        }
        
        [self.aEngine sendDanmaku:[self scrollDanmakuWithFontSize:15 textColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] text:@"滚动弹幕" direction:dir speed:arc4random_uniform(100) + 50]];
    }
    else {
        NSString *str = self.danmakuDirectionLabel.text;
        JHFloatDanmakuDirection dir = JHFloatDanmakuDirectionB2T;
        if ([str isEqualToString:@"顶部弹幕"]) {
            dir = JHFloatDanmakuDirectionT2B;
        }
        [self.aEngine sendDanmaku:[self floatDanmakuWithFontSize:15 textColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] text:@"浮动弹幕" direction:dir]];
    }
}

#pragma mark - 私有方法
//初始化一个浮动弹幕
- (JHFloatDanmaku *)floatDanmakuWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text direction:(JHFloatDanmakuDirection)direction{
    return [[JHFloatDanmaku alloc] initWithFontSize:fontSize textColor:textColor text:text shadowStyle:JHDanmakuShadowStyleShadow font:nil during:3 direction:direction];
}

//初始化一个滚动弹幕
- (JHScrollDanmaku *)scrollDanmakuWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text direction:(JHScrollDanmakuDirection)direction speed:(CGFloat)speed{
    return [[JHScrollDanmaku alloc] initWithFontSize:fontSize textColor:textColor text:text shadowStyle:JHDanmakuShadowStyleShadow font:nil speed:speed direction:direction];
}

- (void)hideMenu{
    CGFloat buttonHeight = self.showMenuButton.frame.size.height;
    CGFloat menuHeight = self.menuView.frame.size.height;
    self.menuBottomConstraint.constant = buttonHeight - menuHeight;
    self.menuShow = NO;
}

- (void)showMenu{
    self.menuBottomConstraint.constant = 0;
    self.menuShow = YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex) return;
    
    if ([alertView.title isEqualToString:@"弹幕类型"]) {
        self.danmakuTypeLabel.text = [alertView buttonTitleAtIndex:buttonIndex];
        if (buttonIndex == 1) {
            self.danmakuDirectionLabel.text = self.scrollDanmakuDirection.firstObject;
        }
        else {
            self.danmakuDirectionLabel.text = self.floatDanmakuDirection.firstObject;
        }
    }
    else {
        self.danmakuDirectionLabel.text = [alertView buttonTitleAtIndex:buttonIndex];
    }
}

#pragma mark - JHDanmakuEngineDelegate
- (NSArray <JHBaseDanmaku*>*)danmakuEngine:(JHDanmakuEngine *)danmakuEngine didSendDanmakuAtTime:(NSUInteger)time {
    if (_loadTestDanmakus) {
        return self.danmakuDic[@(time)];
    }
    return nil;
}

#pragma mark - 懒加载
- (JHDanmakuEngine *)aEngine {
    if(_aEngine == nil) {
        _aEngine = [[JHDanmakuEngine alloc] init];
        _aEngine.delegate = self;
    }
    return _aEngine;
}

- (NSArray *)scrollDanmakuDirection {
    if(_scrollDanmakuDirection == nil) {
        _scrollDanmakuDirection = @[@"右->左",@"左->右",@"上->下",@"下->上"];
    }
    return _scrollDanmakuDirection;
}

- (NSArray *)floatDanmakuDirection {
    if(_floatDanmakuDirection == nil) {
        _floatDanmakuDirection = @[@"底部弹幕",@"顶部弹幕"];
    }
    return _floatDanmakuDirection;
}

- (NSDictionary *)danmakuDic {
    if(_danmakuDic == nil) {
        _danmakuDic = [DanMuDataFormatter dicWithObj:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"]]];
    }
    return _danmakuDic;
}

@end
