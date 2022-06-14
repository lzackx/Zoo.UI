//
//  ZooHierarchyHeaderView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchyHeaderView.h"
#import <Zoo/UIView+Zoo.h>

@interface ZooHierarchyHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZooHierarchyHeaderView

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - Primary
- (void)initUI {    
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(10, 0, self.zoo_width - 10 * 2, self.zoo_height);
}

#pragma mark - Getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

@end
