//
//  ZooHierarchyTitleCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

@class ZooHierarchyCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooHierarchyTitleCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong, readonly) NSLayoutConstraint *titleLabelBottomCons;

@property (nonatomic, strong) ZooHierarchyCellModel *model;

- (void)initUI;

@end

NS_ASSUME_NONNULL_END
