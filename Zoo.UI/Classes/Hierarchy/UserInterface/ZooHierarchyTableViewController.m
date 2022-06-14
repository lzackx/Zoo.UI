//
//  ZooHierarchyTableViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchyTableViewController.h"
#import "ZooHierarchyCategoryModel.h"
#import "ZooHierarchySelectorCell.h"
#import "ZooHierarchySwitchCell.h"
#import "ZooHierarchyHeaderView.h"
#import "ZooHierarchyCellModel.h"
#import <Zoo/ZooDefine.h>

@interface ZooHierarchyTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) UITableViewStyle style;

@property (nonatomic, strong) NSMutableArray <ZooHierarchyCategoryModel *>*dataArray;

@end

@implementation ZooHierarchyTableViewController

#pragma mark - Life cycle
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Over write
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, self.view.zoo_height - self.bigTitleView.zoo_bottom);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooHierarchyCellModel *model = self.dataArray[indexPath.section].items[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellClass];
    [cell setValue:model forKey:@"model"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZooHierarchyCategoryModel *model = self.dataArray[section];
    if (!model.title) {
        return nil;
    }
    ZooHierarchyHeaderView *view = [[ZooHierarchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, ZooScreenWidth, 40)];
    view.titleLabel.text = model.title;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ZooHierarchyCategoryModel *model = self.dataArray[section];
    if (!model.title) {
        return CGFLOAT_MIN;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooHierarchyCellModel *model = self.dataArray[indexPath.section].items[indexPath.row];
    if (model.block) {
        model.block();
    }
}

#pragma mark - Getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[ZooHierarchySwitchCell class] forCellReuseIdentifier:NSStringFromClass([ZooHierarchySwitchCell class])];
        [_tableView registerClass:[ZooHierarchyDetailTitleCell class] forCellReuseIdentifier:NSStringFromClass([ZooHierarchyDetailTitleCell class])];
        [_tableView registerClass:[ZooHierarchySelectorCell class] forCellReuseIdentifier:NSStringFromClass([ZooHierarchySelectorCell class])];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _tableView;
}

- (NSMutableArray<ZooHierarchyCategoryModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
