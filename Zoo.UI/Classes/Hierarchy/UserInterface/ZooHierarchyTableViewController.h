//
//  ZooHierarchyTableViewController.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Zoo/ZooBaseViewController.h>

@class ZooHierarchyCategoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooHierarchyTableViewController : ZooBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong, readonly) NSMutableArray <ZooHierarchyCategoryModel *>*dataArray;

@end

NS_ASSUME_NONNULL_END
