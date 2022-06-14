//
//  ZooViewAlignPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooViewAlignPlugin.h"
#import "ZooViewAlignManager.h"
#import <Zoo/ZooHomeWindow.h>


@implementation ZooViewAlignPlugin

- (void)pluginDidLoad{
    [[ZooViewAlignManager shareInstance] show];
    [[ZooHomeWindow shareInstance] hide];
}

@end
