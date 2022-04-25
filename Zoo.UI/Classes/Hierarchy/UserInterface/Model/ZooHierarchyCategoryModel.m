//
//  ZooHierarchyCategoryModel.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchyCategoryModel.h"

@implementation ZooHierarchyCategoryModel

- (instancetype)initWithTitle:(NSString *)title items:(NSArray <ZooHierarchyCellModel *>*)items {
    if (self = [super init]) {
        _title = title;
        _items = [items copy];
    }
    return self;
}

@end
