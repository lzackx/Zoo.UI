//
//  UIViewController+ZooHierarchy.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZooHierarchy)

- (UIViewController *_Nullable)zoo_currentShowingViewController;

- (void)zoo_showAlertControllerWithMessage:(NSString *)message handler:(nullable void (^)(NSInteger action))handler;

- (void)zoo_showActionSheetWithTitle:(NSString *)title actions:(NSArray *)actions currentAction:(nullable NSString *)currentAction completion:(nullable void (^)(NSInteger index))completion;

- (void)zoo_showTextFieldAlertControllerWithMessage:(NSString *)message text:(nullable NSString *)text handler:(nullable void (^)(NSString * _Nullable))handler;

@end

NS_ASSUME_NONNULL_END
