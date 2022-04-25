//
//  ZooHierarchyWindow.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchyWindow.h"
#import "ZooHierarchyViewController.h"
#import "ZooDefine.h"

@interface ZooHierarchyWindow ()

@end

@implementation ZooHierarchyWindow

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes){
                    if (windowScene.activationState == UISceneActivationStateForegroundActive){
                        self.windowScene = windowScene;
                        break;
                    }
                }
            }
        #endif
        self.windowLevel = UIWindowLevelAlert - 1;
        if (!self.rootViewController) {
            self.rootViewController = [[ZooHierarchyViewController alloc] init];
        }
    }
    return self;
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

@end
