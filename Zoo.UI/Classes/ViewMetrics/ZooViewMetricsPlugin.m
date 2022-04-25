//
//  ZooViewMetricsPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooViewMetricsPlugin.h"
#import "ZooMetricsViewController.h"
#import "ZooHomeWindow.h"

@implementation ZooViewMetricsPlugin

- (void)pluginDidLoad{
    ZooMetricsViewController *vc = [[ZooMetricsViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
