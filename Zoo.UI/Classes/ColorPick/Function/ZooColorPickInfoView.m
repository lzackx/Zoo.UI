//
//  ZooColorPickInfoView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooColorPickInfoView.h"
#import <Zoo/ZooDefine.h>

@interface ZooColorPickInfoView ()

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *colorValueLbl;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ZooColorPickInfoView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        self.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor whiteColor];
            } else {
                return [UIColor secondarySystemBackgroundColor];
            }
        }];
    } else {
#endif
        self.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
    self.layer.cornerRadius = kZooSizeFrom750_Landscape(8);
    self.layer.borderWidth = 1.;
    self.layer.borderColor = [UIColor zoo_colorWithHex:0x999999 andAlpha:0.2].CGColor;
    
    [self addSubview:self.colorView];
    [self addSubview:self.colorValueLbl];
    [self addSubview:self.closeBtn];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    // trait发生了改变
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                [self.closeBtn setImage:[UIImage zoo_xcassetImageNamed:@"zoo_close_dark"] forState:UIControlStateNormal];
            } else {
                [self.closeBtn setImage:[UIImage zoo_xcassetImageNamed:@"zoo_close"] forState:UIControlStateNormal];
            }
        }
    }
#endif
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat colorWidth = kZooSizeFrom750_Landscape(28);
    CGFloat colorHeight = kZooSizeFrom750_Landscape(28);
    self.colorView.frame = CGRectMake(kZooSizeFrom750_Landscape(32), (self.zoo_height - colorHeight) / 2.0, colorWidth, colorHeight);
    
    CGFloat colorValueWidth = kZooSizeFrom750_Landscape(150);
    self.colorValueLbl.frame = CGRectMake(self.colorView.zoo_right + kZooSizeFrom750_Landscape(20), 0, colorValueWidth, self.zoo_height);
    
    CGFloat closeWidth = kZooSizeFrom750_Landscape(44);
    CGFloat closeHeight = kZooSizeFrom750_Landscape(44);
    self.closeBtn.frame = CGRectMake(self.zoo_width - closeWidth - kZooSizeFrom750_Landscape(32), (self.zoo_height - closeHeight) / 2.0, closeWidth, closeHeight);
}

#pragma mark - Public

- (void)setCurrentColor:(NSString *)hexColor{
    self.colorView.backgroundColor = [UIColor zoo_colorWithHexString:hexColor];
    self.colorValueLbl.text = hexColor;
}

#pragma mark - Actions

- (void)closeBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeBtnClicked:onColorPickInfoView:)]) {
        [self.delegate closeBtnClicked:sender onColorPickInfoView:self];
    }
}

#pragma mark - Private
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self];
    // 获取上一个点
    CGPoint prePoint = [touch previousLocationInView:self];
    CGFloat offsetX = currentPoint.x - prePoint.x;
    CGFloat offsetY = currentPoint.y - prePoint.y;

    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
}


#pragma mark - Getter

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.layer.borderWidth = 1.;
        _colorView.layer.borderColor = [UIColor zoo_colorWithHex:0x999999 andAlpha:0.2].CGColor;
    }
    return _colorView;
}

- (UILabel *)colorValueLbl {
    if (!_colorValueLbl) {
        _colorValueLbl = [[UILabel alloc] init];
        _colorValueLbl.textColor = [UIColor zoo_black_1];
        _colorValueLbl.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(28)];
    }
    return _colorValueLbl;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        UIImage *closeImage = [UIImage zoo_xcassetImageNamed:@"zoo_close"];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                closeImage = [UIImage zoo_xcassetImageNamed:@"zoo_close_dark"];
            }
        }
#endif
        [_closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
