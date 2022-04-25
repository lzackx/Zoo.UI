//
//  ZooManager+UI.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooManager+UI.h"
#import "ZooCacheManager+UI.h"

#import <objc/runtime.h>
#import <Zoo/Zooi18NUtil.h>



@implementation ZooManager (UI)

#pragma mark - UI
- (void)addUIPlugins {
    [self addPluginWithModel: [self appColorPickerPluginModel]];
    [self addPluginWithModel: [self appViewCheckPluginModel]];
    [self addPluginWithModel: [self appViewAlignPluginModel]];
    [self addPluginWithModel: [self appViewMetricsPluginModel]];
    [self addPluginWithModel: [self appHierarchyPluginModel]];
}

#pragma mark - Model

- (ZooManagerPluginTypeModel *)appColorPickerPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Color Picker");
    model.desc = ZooLocalizedString(@"Color Picker");
    model.icon = @"zoo_straw";
    model.pluginName = @"ZooColorPickPlugin";
    model.atModule = ZooLocalizedString(@"UI");
    return model;
}

- (ZooManagerPluginTypeModel *)appViewCheckPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"View Checker");
    model.desc = ZooLocalizedString(@"View Checker");
    model.icon = @"zoo_view_check";
    model.pluginName = @"ZooViewCheckPlugin";
    model.atModule = ZooLocalizedString(@"UI");
    return model;
}

- (ZooManagerPluginTypeModel *)appViewAlignPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"View Align");
    model.desc = ZooLocalizedString(@"View Align");
    model.icon = @"zoo_align";
    model.pluginName = @"ZooViewAlignPlugin";
    model.atModule = ZooLocalizedString(@"UI");
    return model;
}

- (ZooManagerPluginTypeModel *)appViewMetricsPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"View Metrics");
    model.desc = ZooLocalizedString(@"View Metrics");
    model.icon = @"zoo_viewmetrics";
    model.pluginName = @"ZooViewMetricsPlugin";
    model.atModule = ZooLocalizedString(@"UI");
    return model;
}

- (ZooManagerPluginTypeModel *)appHierarchyPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Hierarchy");
    model.desc = ZooLocalizedString(@"Hierarchy");
    model.icon = @"zoo_view_level";
    model.pluginName = @"ZooHierarchyPlugin";
    model.atModule = ZooLocalizedString(@"UI");
    return model;
}

@end
