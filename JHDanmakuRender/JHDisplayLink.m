//
//  JHDisplayLink.m
//  CocoaUtils
//
//  Created by Nick Hutchinson on 01/05/2013.
//
//

#import "JHDisplayLink.h"
#import "JHDanmakuPrivateHeader.h"

#if JH_IOS
#import <UIKit/UIKit.h>
#else
#import <CoreVideo/CVDisplayLink.h>
#endif


@interface JHDisplayLink ()
#if JH_IOS
@property (strong, nonatomic) CADisplayLink *iOSDisplayLink;
#else
@property (assign, nonatomic) CVDisplayLinkRef OSXDisplayLink;
@property (assign, atomic) CVTimeStamp timeStamp;
@property (assign, atomic) BOOL isRunning;
#endif

@end

@implementation JHDisplayLink

- (instancetype)init{
    if (self = [super init]) {
#if JH_MACOS
        __unused CVReturn status = CVDisplayLinkCreateWithActiveCGDisplays(&_OSXDisplayLink);
        NSAssert(status == kCVReturnSuccess, @"初始化失败");
        
        __weak typeof(self)weakSelf = self;
        CVDisplayLinkSetOutputHandler(self.OSXDisplayLink, ^CVReturn(CVDisplayLinkRef  _Nonnull displayLink, const CVTimeStamp * _Nonnull inNow, const CVTimeStamp * _Nonnull inOutputTime, CVOptionFlags flagsIn, CVOptionFlags * _Nonnull flagsOut) {
            __strong typeof(weakSelf)self = weakSelf;
            if (!self) {
                return kCVReturnError;
            }
            
            if (self.isRunning == false) {
                CVDisplayLinkStop(displayLink);
            }
            else {
                self.timeStamp = *inOutputTime;
                
                if (self.isRunning) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate displayLinkDidCallback];
                    });
                }
            }
            
            return kCVReturnSuccess;
        });
#endif
    }
    
    return self;
}

- (void)dealloc {
#if JH_IOS
    [self stop];
#else
    CVDisplayLinkRelease(self.OSXDisplayLink);
#endif
}

- (void)start {
#if JH_IOS
    [self stop];
    self.iOSDisplayLink = [CADisplayLink displayLinkWithTarget:self.delegate selector:@selector(displayLinkDidCallback)];
    [self.iOSDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
#else
    if (self.isRunning) return;
    self.isRunning = true;
    CVDisplayLinkStart(self.OSXDisplayLink);
#endif
}

- (void)stop {
#if JH_IOS
    if (self.iOSDisplayLink) {
        [self.iOSDisplayLink invalidate];
    }
#else
    if (self.isRunning == false) return;
    self.isRunning = false;
#endif
}

@end
