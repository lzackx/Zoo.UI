//
//  NSObject+ZooHierarchy.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSNotificationName _Nonnull const ZooHierarchyChangeNotificationName;

@class ZooHierarchyCategoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZooHierarchy)

- (NSArray <ZooHierarchyCategoryModel *>*)zoo_hierarchyCategoryModels;

- (void)zoo_showIntAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;

- (void)zoo_showFrameAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;

- (void)zoo_showColorAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;

- (void)zoo_showFontAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;

- (UIColor *)zoo_hashColor;

@end

@interface UIView (ZooHierarchy)

- (NSArray <ZooHierarchyCategoryModel *>*)zoo_sizeHierarchyCategoryModels;

@end

NS_ASSUME_NONNULL_END
