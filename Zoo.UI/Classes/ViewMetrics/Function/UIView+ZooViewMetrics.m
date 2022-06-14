//
//  UIView+ZooViewMetrics.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "UIView+ZooViewMetrics.h"
#import "ZooViewMetricsConfig.h"
#import <Zoo/NSObject+Zoo.h>
#import <objc/runtime.h>
#import <Zoo/ZooDefine.h>


@interface UIView ()

@property (nonatomic ,strong) CALayer *metricsBorderLayer;

@end


@implementation UIView (ZooViewMetrics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] zoo_swizzleInstanceMethodWithOriginSel:@selector(layoutSubviews) swizzledSel:@selector(zoo_layoutSubviews)];
    });
}

- (void)zoo_layoutSubviews
{
    [self zoo_layoutSubviews];
    if (ZooViewMetricsConfig.defaultConfig.opened) {
        [self zooMetricsRecursiveEnable:ZooViewMetricsConfig.defaultConfig.enable];
    }
}

- (void)zooMetricsRecursiveEnable:(BOOL)enable
{
    // 状态栏不显示元素边框
    UIWindow *statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
    if (statusBarWindow && [self isDescendantOfView:statusBarWindow]) {
        return;
    }

    for (UIView *subView in self.subviews) {
        [subView zooMetricsRecursiveEnable:enable];
    }
    
    if (enable) {
        if (!self.metricsBorderLayer) {
            UIColor *borderColor = ZooViewMetricsConfig.defaultConfig.borderColor ? ZooViewMetricsConfig.defaultConfig.borderColor : UIColor.zoo_randomColor;
            self.metricsBorderLayer = ({
                CALayer *layer = CALayer.new;
                layer.borderWidth = ZooViewMetricsConfig.defaultConfig.borderWidth;
                layer.borderColor = borderColor.CGColor;
                layer;
            });
            [self.layer addSublayer:self.metricsBorderLayer];
        }
        
        self.metricsBorderLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.metricsBorderLayer.hidden = NO;
    } else if (self.metricsBorderLayer) {
        self.metricsBorderLayer.hidden = YES;
    }
}

- (void)setMetricsBorderLayer:(CALayer *)metricsBorderLayer
{
    objc_setAssociatedObject(self, @selector(metricsBorderLayer), metricsBorderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)metricsBorderLayer
{
    return objc_getAssociatedObject(self, _cmd);
}
@end
