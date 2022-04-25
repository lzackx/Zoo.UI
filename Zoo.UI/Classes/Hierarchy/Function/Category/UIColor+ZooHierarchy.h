//
//  UIColor+ZooHierarchy.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZooHierarchy)

- (NSString *)zoo_HexString;

- (NSString *)zoo_description;

- (NSString *_Nullable)zoo_systemColorName;

@end

NS_ASSUME_NONNULL_END
