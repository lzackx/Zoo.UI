#import "ZooMoveView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZooHierarchyInfoViewAction) {
    ZooHierarchyInfoViewActionShowParent,
    ZooHierarchyInfoViewActionShowSubview,
    ZooHierarchyInfoViewActionShowMoreInfo
};

@class ZooHierarchyInfoView;

@protocol ZooHierarchyInfoViewDelegate <NSObject>

- (void)hierarchyInfoView:(ZooHierarchyInfoView *)view didSelectAt:(ZooHierarchyInfoViewAction)action;

- (void)hierarchyInfoViewDidSelectCloseButton:(ZooHierarchyInfoView *)view;

@end

@interface ZooHierarchyInfoView : ZooMoveView

@property (nonatomic, weak, nullable) id <ZooHierarchyInfoViewDelegate> delegate;

@property (nonatomic, strong, nullable, readonly) UIView *selectedView;

@property (nonatomic, strong, readonly) UIButton *closeButton;

- (void)updateSelectedView:(UIView *)view;

- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
