//
//  ZooColorPickWindow.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

@interface ZooColorPickWindow : UIWindow

+ (ZooColorPickWindow *)shareInstance;

- (void)show;

- (void)hide;

@end
