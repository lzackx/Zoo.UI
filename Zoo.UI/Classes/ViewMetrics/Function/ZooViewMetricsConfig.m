//
//  ZooViewMetricsManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooViewMetricsConfig.h"
#import "UIView+ZooViewMetrics.h"

@implementation ZooViewMetricsConfig

+ (instancetype)defaultConfig
{
    static ZooViewMetricsConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ZooViewMetricsConfig new];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borderWidth = 1;
        //self.enable = NO;
    }
    return self;
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        [window zooMetricsRecursiveEnable:enable];
    }
}

@end
