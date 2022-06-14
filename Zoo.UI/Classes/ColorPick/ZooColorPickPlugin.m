//
//  ZooColorPickPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooColorPickPlugin.h"
#import "ZooColorPickWindow.h"
#import <Zoo/ZooHomeWindow.h>
#import "ZooColorPickInfoWindow.h"

@implementation ZooColorPickPlugin

- (void)pluginDidLoad {
    [[ZooColorPickWindow shareInstance] show];
    [[ZooColorPickInfoWindow shareInstance] show];
    [[ZooHomeWindow shareInstance] hide];
}

@end
