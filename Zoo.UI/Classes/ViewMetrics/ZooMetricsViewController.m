//
//  ZooMetricsViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooMetricsViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooDefine.h>
#import "ZooViewMetricsConfig.h"

@interface ZooMetricsViewController () <ZooSwitchViewDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;

@end

@implementation ZooMetricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZooLocalizedString(@"布局边框");
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"布局边框开关") switchOn:[ZooViewMetricsConfig defaultConfig].enable];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
}

- (BOOL)needBigTitleView{
    return YES;
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [ZooViewMetricsConfig defaultConfig].opened = YES;
    [ZooViewMetricsConfig defaultConfig].enable = on;
}

@end
