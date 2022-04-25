//
//  ZooHierarchyCellModel.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooHierarchyCellModel : NSObject

@property (nonatomic, copy, nullable, readonly) NSString *title;

@property (nonatomic, copy, readonly) NSString *cellClass;

// Style1
@property (nonatomic, assign) BOOL flag;

// Style2 / Style3
@property (nonatomic, copy, nullable, readonly) NSString *detailTitle;

// Style4
@property (nonatomic, assign) CGFloat value;

@property (nonatomic, assign, readonly) CGFloat minValue;

@property (nonatomic, assign, readonly) CGFloat maxValue;

// Block
@property (nonatomic, copy, nullable) void (^block)(void);

@property (nonatomic, copy, nullable) void (^changePropertyBlock)(__nullable id obj);

// Separator
@property (nonatomic, assign) UIEdgeInsets separatorInsets;

// ZooHierarchySwitchCell
- (instancetype)initWithTitle:(NSString *_Nullable)title flag:(BOOL)flag;
- (instancetype)initWithTitle:(NSString *_Nullable)title detailTitle:(NSString *_Nullable)detailTitle flag:(BOOL)flag;

// ZooHierarchyDetailTitleCell
- (instancetype)initWithTitle:(NSString *_Nullable)title detailTitle:(NSString *_Nullable)detailTitle;

- (ZooHierarchyCellModel *)normalInsets;

- (ZooHierarchyCellModel *)noneInsets;

@end

NS_ASSUME_NONNULL_END
