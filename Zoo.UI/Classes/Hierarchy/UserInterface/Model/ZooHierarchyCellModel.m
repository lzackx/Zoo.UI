//
//  ZooHierarchyCellModel.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchyCellModel.h"
#import "ZooHierarchyDetailTitleCell.h"
#import "ZooHierarchySelectorCell.h"
#import "ZooHierarchySwitchCell.h"
#import "ZooDefine.h"

@implementation ZooHierarchyCellModel

- (instancetype)initWithTitle:(NSString *)title flag:(BOOL)flag {
    return [self initWithTitle:title detailTitle:nil flag:flag];
}

- (instancetype)initWithTitle:(NSString *_Nullable)title detailTitle:(NSString *_Nullable)detailTitle flag:(BOOL)flag {
    if (self = [super init]) {
        _title = [title copy];
        _detailTitle = [detailTitle copy];
        _flag = flag;
        _cellClass = NSStringFromClass(ZooHierarchySwitchCell.class);
        _separatorInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle {
    if (self = [super init]) {
        _title = [title copy];
        _detailTitle = [detailTitle copy];
        _cellClass = NSStringFromClass(ZooHierarchyDetailTitleCell.class);
        _separatorInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}

- (ZooHierarchyCellModel *)normalInsets {
    self.separatorInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    return self;
}

- (ZooHierarchyCellModel *)noneInsets {
    self.separatorInsets = UIEdgeInsetsMake(0, ZooScreenWidth, 0, 0);
    return self;
}

- (void)setBlock:(void (^)(void))block {
    if (_block != block) {
        _block = [block copy];
        _cellClass = NSStringFromClass(block ? ZooHierarchySelectorCell.class : ZooHierarchyDetailTitleCell.class);
    }
}

@end
