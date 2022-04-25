//
//  ZooColorPickInfoWindow.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooColorPickInfoWindow : UIWindow

+ (ZooColorPickInfoWindow *)shareInstance;

- (void)show;

- (void)hide;

- (void)setCurrentColor:(NSString *)hexColor;

@end

NS_ASSUME_NONNULL_END
