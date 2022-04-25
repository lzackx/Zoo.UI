//
//  ZooHierarchyViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchyViewController.h"
#import "ZooHierarchyDetailViewController.h"
#import "UIViewController+ZooHierarchy.h"
#import "ZooHierarchyPickerView.h"
#import "NSObject+ZooHierarchy.h"
#import "ZooHierarchyInfoView.h"
#import "ZooHierarchyHelper.h"
#import "ZooHierarchyWindow.h"
#import "UIView+Zoo.h"
#import "ZooDefine.h"

@interface ZooHierarchyViewController ()<ZooHierarchyViewDelegate, ZooHierarchyInfoViewDelegate>

@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) ZooHierarchyPickerView *pickerView;

@property (nonatomic, strong) ZooHierarchyInfoView *infoView;

@property (nonatomic, strong) NSMutableSet *observeViews;

@property (nonatomic, strong) NSMutableDictionary *borderViews;

@end

@implementation ZooHierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.observeViews = [NSMutableSet set];
    self.borderViews = [[NSMutableDictionary alloc] init];
    
    CGFloat height = 100;
    self.infoView = [[ZooHierarchyInfoView alloc] initWithFrame:CGRectMake(10, ZooScreenHeight - 10 * 2 - height, ZooScreenWidth - 10 * 2, height)];
    self.infoView.delegate = self;
    [self.view addSubview:self.infoView];
    
    [self.view addSubview:self.borderView];
    
    self.pickerView = [[ZooHierarchyPickerView alloc] initWithFrame:CGRectMake((self.view.zoo_width - 60) / 2.0, (self.view.zoo_height - 60) / 2.0, 60, 60)];
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
}

- (void)dealloc {
    for (UIView *view in self.observeViews) {
        [self stopObserveView:view];
    }
    [self.observeViews removeAllObjects];
}

#pragma mark - Primary
- (void)beginObserveView:(UIView *)view borderWidth:(CGFloat)borderWidth {
    if ([self.observeViews containsObject:view]) {
        return;
    }
    
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:borderView];
    [self.view sendSubviewToBack:borderView];
    borderView.layer.borderColor = view.zoo_hashColor.CGColor;
    borderView.layer.borderWidth = borderWidth;
    borderView.frame = [self frameInLocalForView:view];
    [self.borderViews setObject:borderView forKey:@(view.hash)];

    [view addObserver:self forKeyPath:@"frame" options:0 context:NULL];
}

- (void)stopObserveView:(UIView *)view {
    if (![self.observeViews containsObject:view]) {
        return;
    }
    
    UIView *borderView = self.borderViews[@(view.hash)];
    [borderView removeFromSuperview];
    [view removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([object isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)object;
        [self updateOverlayIfNeeded:view];
    }
}

- (void)updateOverlayIfNeeded:(UIView *)view {
    UIView *borderView = self.borderViews[@(view.hash)];
    if (borderView) {
        borderView.frame = [self frameInLocalForView:view];
    }
}

- (CGRect)frameInLocalForView:(UIView *)view {
    UIWindow *window = [ZooUtil getKeyWindow];
    CGRect rect = [view convertRect:view.bounds toView:window];
    rect = [self.view convertRect:rect fromView:window];
    return rect;
}

- (UIView *)findSelectedViewInViews:(NSArray *)selectedViews {
    if ([ZooHierarchyHelper shared].isHierarchyIgnorePrivateClass) {
        NSMutableArray *views = [[NSMutableArray alloc] init];
        for (UIView *view in selectedViews) {
            if (![NSStringFromClass(view.class) hasPrefix:@"_"]) {
                [views addObject:view];
            }
        }
        return [views lastObject];
    } else {
        return [selectedViews lastObject];
    }
}

- (NSArray <UIView *>*)findParentViewsBySelectedView:(UIView *)selectedView {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    UIView *view = [selectedView superview];
    while (view) {
        if ([ZooHierarchyHelper shared].isHierarchyIgnorePrivateClass) {
            if (![NSStringFromClass(view.class) hasPrefix:@"_"]) {
                [views addObject:view];
            }
        } else {
            [views addObject:view];
        }
        view = view.superview;
    }
    return [views copy];
}

- (NSArray <UIView *>*)findSubviewsBySelectedView:(UIView *)selectedView {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIView *view in selectedView.subviews) {
        if ([ZooHierarchyHelper shared].isHierarchyIgnorePrivateClass) {
            if (![NSStringFromClass(view.class) hasPrefix:@"_"]) {
                [views addObject:view];
            }
        } else {
            [views addObject:view];
        }
    }
    return [views copy];
}

#pragma mark - LLHierarchyPickerViewDelegate
- (void)hierarchyView:(ZooHierarchyPickerView *)view didMoveTo:(NSArray <UIView *>*)selectedViews {
    
    @synchronized (self) {
        for (UIView *view in self.observeViews) {
            [self stopObserveView:view];
        }
        [self.observeViews removeAllObjects];
        
        for (NSInteger i = selectedViews.count - 1; i >= 0; i--) {
            UIView *view = selectedViews[i];
            CGFloat borderWidth = 1;
            if (i == selectedViews.count - 1) {
                borderWidth = 2;
            }
            [self beginObserveView:view borderWidth:borderWidth];
        }
        [self.observeViews addObjectsFromArray:selectedViews];
    }

    [self.infoView updateSelectedView:[self findSelectedViewInViews:selectedViews]];
}

#pragma mark - ZooHierarchyInfoViewDelegate
- (void)hierarchyInfoView:(ZooHierarchyInfoView *)view didSelectAt:(ZooHierarchyInfoViewAction)action {
    UIView *selectView = self.infoView.selectedView;
    if (selectView == nil) {
        return;
    }
    switch (action) {
        case ZooHierarchyInfoViewActionShowMoreInfo:{
            [self showHierarchyInfo:selectView];
        }
            break;
        case ZooHierarchyInfoViewActionShowParent: {
            [self showParentSheet:selectView];
        }
            break;
        case ZooHierarchyInfoViewActionShowSubview: {
            [self showSubviewSheet:selectView];
        }
            break;
    }
}

- (void)hierarchyInfoViewDidSelectCloseButton:(ZooHierarchyInfoView *)view {
    [[ZooHierarchyHelper shared].window hide];
    [ZooHierarchyHelper shared].window = nil;
}

- (void)showHierarchyInfo:(UIView *)selectView {
    ZooHierarchyDetailViewController *vc = [[ZooHierarchyDetailViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.selectView = selectView;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showParentSheet:(UIView *)selectView {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    __block NSArray *parentViews = [self findParentViewsBySelectedView:selectView];
    for (UIView *view in parentViews) {
        [actions addObject:NSStringFromClass(view.class)];
    }
    __weak typeof(self) weakSelf = self;
    [self zoo_showActionSheetWithTitle:@"Parent Views" actions:actions currentAction:nil completion:^(NSInteger index) {
        [weakSelf setNewSelectView:parentViews[index]];
    }];
}

- (void)showSubviewSheet:(UIView *)selectView {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    __block NSArray *subviews = [self findSubviewsBySelectedView:selectView];
    for (UIView *view in subviews) {
        [actions addObject:NSStringFromClass(view.class)];
    }
    __weak typeof(self) weakSelf = self;
    [self zoo_showActionSheetWithTitle:@"Subviews" actions:actions currentAction:nil completion:^(NSInteger index) {
        [weakSelf setNewSelectView:subviews[index]];
    }];
}

- (void)setNewSelectView:(UIView *)view {
    [self hierarchyView:self.pickerView didMoveTo:@[view]];
}

#pragma mark - Getters and setters
- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderWidth = 2;
    }
    return _borderView;
}

@end
