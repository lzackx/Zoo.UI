//
//  ZooViewCheckManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@interface ZooViewCheckManager : NSObject

+ (ZooViewCheckManager *)shareInstance;

- (void)show;

- (void)hidden;

@end
