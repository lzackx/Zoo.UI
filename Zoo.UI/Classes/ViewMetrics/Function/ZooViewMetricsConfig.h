//
//  ZooViewMetricsManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZooViewMetricsConfig : NSObject

@property (nonatomic, strong) UIColor *borderColor;     //default randomColor
@property (nonatomic, assign) CGFloat borderWidth;      //default 1
@property (nonatomic, assign) BOOL enable;              //default NO
@property (nonatomic, assign) BOOL opened;              //default NO
+ (instancetype)defaultConfig;

@end

