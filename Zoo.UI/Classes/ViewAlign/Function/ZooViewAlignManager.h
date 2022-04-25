//
//  ZooViewAlignManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@interface ZooViewAlignManager : NSObject

+ (ZooViewAlignManager *)shareInstance;

- (void)show;

- (void)hidden;

@end
