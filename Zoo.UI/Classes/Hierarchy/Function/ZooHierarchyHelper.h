//
//  ZooHierarchyHelper.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZooHierarchyWindow;

NS_ASSUME_NONNULL_BEGIN

@interface ZooHierarchyHelper : NSObject

+ (instancetype _Nonnull)shared;

// ZooHierarchyWindow isn't a shared instance, so we need a object onwer it when show, and free it when hide.
@property (nonatomic, strong, nullable) ZooHierarchyWindow *window;

@property (nonatomic, assign) BOOL isHierarchyIgnorePrivateClass;

- (NSArray <UIWindow *>*)allWindows;

- (NSArray <UIWindow *>*)allWindowsIgnorePrefix:(NSString *_Nullable)prefix;

@end

NS_ASSUME_NONNULL_END
