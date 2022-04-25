//
//  ZooHierarchyCategoryModel.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@class ZooHierarchyCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooHierarchyCategoryModel : NSObject

@property (nonatomic, strong, readonly, nullable) NSString *title;

@property (nonatomic, strong, readonly) NSArray <ZooHierarchyCellModel *>*items;

- (instancetype)initWithTitle:(NSString *_Nullable)title items:(NSArray <ZooHierarchyCellModel *>*)items;

@end

NS_ASSUME_NONNULL_END
