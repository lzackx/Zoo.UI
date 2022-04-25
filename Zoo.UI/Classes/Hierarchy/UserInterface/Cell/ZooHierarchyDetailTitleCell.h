//
//  ZooHierarchyDetailTitleCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchyTitleCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZooHierarchyDetailTitleCell : ZooHierarchyTitleCell

@property (nonatomic, strong, readonly) UILabel *detailLabel;

@property (nonatomic, strong, readonly) NSLayoutConstraint *detailLabelRightCons;

@end

NS_ASSUME_NONNULL_END
