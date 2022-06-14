#import "ZooHierarchyInfoView.h"
#import "UIColor+ZooHierarchy.h"
#import <Zoo/UIView+Zoo.h>
#import <Zoo/ZooDefine.h>
#import "NSObject+ZooHierarchy.h"
#import "ZooHierarchyFormatterTool.h"

@interface ZooHierarchyInfoView ()

@property (nonatomic, strong, nullable) UIView *selectedView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *frameLabel;

@property (nonatomic, strong) UILabel *backgroundColorLabel;

@property (nonatomic, strong) UILabel *textColorLabel;

@property (nonatomic, strong) UILabel *fontLabel;

@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UIView *actionContentView;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UIButton *parentViewsButton;

@property (nonatomic, strong) UIButton *subviewsButton;

@property (nonatomic, assign) CGFloat actionContentViewHeight;

- (void)hierarchyInfoViewInit;

@end

@implementation ZooHierarchyInfoView

- (void)updateSelectedView:(UIView *)selectedView {

    UIView *view = selectedView;

    if (!view) {
        return;
    }

    if (self.selectedView == view) {
        return;
    }

    self.moreButton.enabled = YES;
    self.parentViewsButton.enabled = view.superview != nil;
    self.subviewsButton.enabled = view.subviews.count;

    self.selectedView = view;

    NSDictionary *boldAttri = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
    NSDictionary *attri = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};

    NSMutableAttributedString *name = [[NSMutableAttributedString alloc] initWithString:@"Name: " attributes:boldAttri];
    [name appendAttributedString:[[NSAttributedString alloc] initWithString:NSStringFromClass(view.class) attributes:attri]];

    self.contentLabel.attributedText = name;

    NSMutableAttributedString *frame = [[NSMutableAttributedString alloc] initWithString:@"Frame: " attributes:boldAttri];
    [frame appendAttributedString:[[NSAttributedString alloc] initWithString:[ZooHierarchyFormatterTool stringFromFrame:view.frame] attributes:attri]];

    self.frameLabel.attributedText = frame;

    if (view.backgroundColor) {
        NSMutableAttributedString *color = [[NSMutableAttributedString alloc] initWithString:@"Background: " attributes:boldAttri];
        [color appendAttributedString:[[NSAttributedString alloc] initWithString:[view.backgroundColor zoo_description] attributes:attri]];
        self.backgroundColorLabel.attributedText = color;
    } else {
        self.backgroundColorLabel.attributedText = nil;
    }

    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *) view;
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc] initWithString:@"Text Color: " attributes:boldAttri];
        [textColor appendAttributedString:[[NSAttributedString alloc] initWithString:[label.textColor zoo_description] attributes:attri]];
        self.textColorLabel.attributedText = textColor;

        NSMutableAttributedString *font = [[NSMutableAttributedString alloc] initWithString:@"Font: " attributes:boldAttri];
        [font appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f", label.font.pointSize] attributes:attri]];
        self.fontLabel.attributedText = font;
    } else {
        self.textColorLabel.attributedText = nil;
        self.fontLabel.attributedText = nil;
    }

    if (view.tag != 0) {
        NSMutableAttributedString *tag = [[NSMutableAttributedString alloc] initWithString:@"Tag: " attributes:boldAttri];
        [tag appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long) view.tag] attributes:attri]];
        self.tagLabel.attributedText = tag;
    } else {
        self.tagLabel.attributedText = nil;
    }

    [self.contentLabel sizeToFit];
    [self.frameLabel sizeToFit];
    [self.backgroundColorLabel sizeToFit];
    [self.textColorLabel sizeToFit];
    [self.fontLabel sizeToFit];
    [self.tagLabel sizeToFit];

    [self updateHeightIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.closeButton.frame = CGRectMake(self.zoo_width - 10 - 30, 10, 30, 30);

    self.actionContentView.frame = CGRectMake(0, self.zoo_height - self.actionContentViewHeight - 10, self.zoo_width, self.actionContentViewHeight);

    self.parentViewsButton.frame = CGRectMake(10, 0, self.actionContentView.zoo_width / 2.0 - 10 * 1.5, (self.actionContentView.zoo_height - 10) / 2.0);

    self.subviewsButton.frame = CGRectMake(self.actionContentView.zoo_width / 2.0 + 10 * 0.5, self.parentViewsButton.zoo_top, self.parentViewsButton.zoo_width, self.parentViewsButton.zoo_height);

    self.moreButton.frame = CGRectMake(10, self.parentViewsButton.zoo_bottom + 10, self.actionContentView.zoo_width - 10 * 2, self.parentViewsButton.zoo_height);

    self.contentLabel.frame = CGRectMake(10, 10, self.closeButton.zoo_x - 10 - 10, self.contentLabel.zoo_height);

    self.frameLabel.frame = CGRectMake(self.contentLabel.zoo_x, self.contentLabel.zoo_bottom, self.contentLabel.zoo_width, self.frameLabel.zoo_height);

    self.backgroundColorLabel.frame = CGRectMake(self.contentLabel.zoo_x, self.frameLabel.zoo_bottom, self.contentLabel.zoo_width, self.backgroundColorLabel.zoo_height);

    self.textColorLabel.frame = CGRectMake(self.contentLabel.zoo_x, self.backgroundColorLabel.zoo_bottom, self.contentLabel.zoo_width, self.textColorLabel.zoo_height);

    self.fontLabel.frame = CGRectMake(self.contentLabel.zoo_x, self.textColorLabel.zoo_bottom, self.contentLabel.zoo_width, self.fontLabel.zoo_height);

    self.tagLabel.frame = CGRectMake(self.contentLabel.zoo_x, self.fontLabel.zoo_bottom, self.contentLabel.zoo_width, self.tagLabel.zoo_height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self hierarchyInfoViewInit];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self hierarchyInfoViewInit];
    }

    return self;
}

- (void)hierarchyInfoViewInit {
    self.layer.borderColor = [UIColor zoo_black_1].CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];

    self.actionContentViewHeight = 80;

    [self addSubview:self.closeButton];
    [self addSubview:self.contentLabel];
    [self addSubview:self.frameLabel];
    [self addSubview:self.backgroundColorLabel];
    [self addSubview:self.textColorLabel];
    [self addSubview:self.fontLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.actionContentView];
    [self.actionContentView addSubview:self.parentViewsButton];
    [self.actionContentView addSubview:self.subviewsButton];
    [self.actionContentView addSubview:self.moreButton];

    [self updateHeightIfNeeded];
}

#pragma mark - Event responses

- (void)buttonClicked:(UIButton *)sender {
    [self.delegate hierarchyInfoView:self didSelectAt:sender.tag];
}

- (void)closeButtonClicked:(UIButton *)sender {
    [self.delegate hierarchyInfoViewDidSelectCloseButton:self];
}

- (void)frameLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.selectedView zoo_showFrameAlertAndAutomicSetWithKeyPath:@"frame"];
}

- (void)backgroundColorLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.selectedView zoo_showColorAlertAndAutomicSetWithKeyPath:@"backgroundColor"];
}

- (void)textColorLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.selectedView zoo_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
}

- (void)fontLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.selectedView zoo_showFontAlertAndAutomicSetWithKeyPath:@"font"];
}

- (void)tagLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.selectedView zoo_showIntAlertAndAutomicSetWithKeyPath:@"tag"];
}

#pragma mark - Primary

- (void)updateHeightIfNeeded {
    CGFloat contentHeight = self.contentLabel.zoo_height + self.frameLabel.zoo_height + self.backgroundColorLabel.zoo_height + self.textColorLabel.zoo_height + self.fontLabel.zoo_height + self.tagLabel.zoo_height;
    CGFloat height = 10 + MAX(contentHeight, 10 + 30/*self.closeButton.zoo_height*/) + 10 + self.actionContentViewHeight + 10;
    if (height != self.zoo_height) {
        self.zoo_height = height;
        if (!self.isMoved) {
            if (self.zoo_bottom != ZooScreenHeight - 10 * 2) {
                self.zoo_bottom = ZooScreenHeight - 10 * 2;
            }
        }
    }
}

#pragma mark - Getters and setters

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage zoo_xcassetImageNamed:@"zoo_close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor zoo_black_1];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _contentLabel;
}

- (UILabel *)frameLabel {
    if (!_frameLabel) {
        _frameLabel = [[UILabel alloc] init];
        _frameLabel.font = [UIFont systemFontOfSize:14];
        _frameLabel.textColor = [UIColor zoo_black_1];
        _frameLabel.numberOfLines = 0;
        _frameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frameLabelTapGestureRecognizer:)];
        _frameLabel.userInteractionEnabled = YES;
        [_frameLabel addGestureRecognizer:tap];
    }
    return _frameLabel;
}

- (UILabel *)backgroundColorLabel {
    if (!_backgroundColorLabel) {
        _backgroundColorLabel = [[UILabel alloc] init];
        _backgroundColorLabel.font = [UIFont systemFontOfSize:14];
        _backgroundColorLabel.textColor = [UIColor zoo_black_1];
        _backgroundColorLabel.numberOfLines = 0;
        _backgroundColorLabel.lineBreakMode = NSLineBreakByCharWrapping;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundColorLabelTapGestureRecognizer:)];
        _backgroundColorLabel.userInteractionEnabled = YES;
        [_backgroundColorLabel addGestureRecognizer:tap];
    }
    return _backgroundColorLabel;
}

- (UILabel *)textColorLabel {
    if (!_textColorLabel) {
        _textColorLabel = [[UILabel alloc] init];
        _textColorLabel.font = [UIFont systemFontOfSize:14];
        _textColorLabel.textColor = [UIColor zoo_black_1];
        _textColorLabel.numberOfLines = 0;
        _textColorLabel.lineBreakMode = NSLineBreakByCharWrapping;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textColorLabelTapGestureRecognizer:)];
        _textColorLabel.userInteractionEnabled = YES;
        [_textColorLabel addGestureRecognizer:tap];
    }
    return _textColorLabel;
}

- (UILabel *)fontLabel {
    if (!_fontLabel) {
        _fontLabel = [[UILabel alloc] init];
        _fontLabel.font = [UIFont systemFontOfSize:14];
        _fontLabel.textColor = [UIColor zoo_black_1];
        _fontLabel.numberOfLines = 0;
        _fontLabel.lineBreakMode = NSLineBreakByCharWrapping;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontLabelTapGestureRecognizer:)];
        _fontLabel.userInteractionEnabled = YES;
        [_fontLabel addGestureRecognizer:tap];
    }
    return _fontLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont systemFontOfSize:14];
        _tagLabel.textColor = [UIColor zoo_black_1];
        _tagLabel.numberOfLines = 0;
        _tagLabel.lineBreakMode = NSLineBreakByCharWrapping;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagLabelTapGestureRecognizer:)];
        _tagLabel.userInteractionEnabled = YES;
        [_tagLabel addGestureRecognizer:tap];
    }
    return _tagLabel;
}

- (UIView *)actionContentView {
    if (!_actionContentView) {
        _actionContentView = [[UIView alloc] init];
    }
    return _actionContentView;
}

- (UIButton *)parentViewsButton {
    if (!_parentViewsButton) {
        _parentViewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_parentViewsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_parentViewsButton setTitle:@"Parent Views" forState:UIControlStateNormal];
        [_parentViewsButton setTitleColor:[UIColor zoo_black_1] forState:UIControlStateNormal];
        _parentViewsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _parentViewsButton.backgroundColor = [UIColor whiteColor];
        _parentViewsButton.layer.borderColor = [UIColor zoo_black_1].CGColor;
        _parentViewsButton.layer.borderWidth = 1;
        _parentViewsButton.layer.cornerRadius = 5;
        _parentViewsButton.layer.masksToBounds = YES;
        _parentViewsButton.tintColor = [UIColor zoo_black_1];
        _parentViewsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_parentViewsButton setImage:[[UIImage zoo_xcassetImageNamed:@"zoo_hierarchy_parent"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _parentViewsButton.tag = ZooHierarchyInfoViewActionShowParent;
        _parentViewsButton.enabled = NO;
    }
    return _parentViewsButton;
}

- (UIButton *)subviewsButton {
    if (!_subviewsButton) {
        _subviewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subviewsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_subviewsButton setTitle:@"Subviews" forState:UIControlStateNormal];
        [_subviewsButton setTitleColor:[UIColor zoo_black_1] forState:UIControlStateNormal];
        _subviewsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _subviewsButton.backgroundColor = [UIColor whiteColor];
        _subviewsButton.layer.borderColor = [UIColor zoo_black_1].CGColor;
        _subviewsButton.layer.borderWidth = 1;
        _subviewsButton.layer.cornerRadius = 5;
        _subviewsButton.layer.masksToBounds = YES;
        _subviewsButton.tintColor = [UIColor zoo_black_1];
        _subviewsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_subviewsButton setImage:[[UIImage zoo_xcassetImageNamed:@"zoo_hierarchy_subview"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _subviewsButton.tag = ZooHierarchyInfoViewActionShowSubview;
        _subviewsButton.enabled = NO;
    }
    return _subviewsButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setTitle:@"More Info" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor zoo_black_1] forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _moreButton.backgroundColor = [UIColor whiteColor];
        _moreButton.layer.borderColor = [UIColor zoo_black_1].CGColor;
        _moreButton.layer.borderWidth = 1;
        _moreButton.layer.cornerRadius = 5;
        _moreButton.layer.masksToBounds = YES;
        _moreButton.tintColor = [UIColor zoo_black_1];
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_moreButton setImage:[[UIImage zoo_xcassetImageNamed:@"zoo_hierarchy_info"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _moreButton.tag = ZooHierarchyInfoViewActionShowMoreInfo;
        _moreButton.enabled = NO;
    }
    return _moreButton;
}

@end
