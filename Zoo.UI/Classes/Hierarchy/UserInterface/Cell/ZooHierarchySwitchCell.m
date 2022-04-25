//
//  ZooHierarchySwitchCell.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchySwitchCell.h"
#import "ZooHierarchyCellModel.h"

@interface ZooHierarchySwitchCell ()

@property (nonatomic, strong) UISwitch *swit;

@end

@implementation ZooHierarchySwitchCell

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self.contentView addSubview:self.swit];
    
    [self.contentView removeConstraint:self.detailLabelRightCons];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.detailLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:10 / 2.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.swit.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.swit.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:51];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:31];
    self.swit.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[left, right, centerY, width, height]];
}

#pragma mark - Event responses
- (void)switchValueChanged:(UISwitch *)sender {
    self.model.flag = sender.isOn;
    if (self.model.changePropertyBlock) {
        self.model.changePropertyBlock(@(sender.isOn));
    }
}

#pragma mark - Getters and settings
- (void)setModel:(ZooHierarchyCellModel *)model {
    [super setModel:model];
    _swit.on = model.flag;
}

- (UISwitch *)swit {
    if (!_swit) {
        _swit = [[UISwitch alloc] init];
        [_swit addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _swit;
}

@end
