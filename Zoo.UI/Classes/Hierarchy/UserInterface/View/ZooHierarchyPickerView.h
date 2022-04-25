#import "ZooPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZooHierarchyPickerView;

@protocol ZooHierarchyViewDelegate <NSObject>

- (void)hierarchyView:(ZooHierarchyPickerView *)view didMoveTo:(nullable NSArray <UIView *> *)selectedViews;

@end

@interface ZooHierarchyPickerView : ZooPickerView

@property (nonatomic, weak, nullable) id <ZooHierarchyViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
