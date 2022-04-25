#import "ZooPickerView.h"
#import <Zoo/UIImage+Zoo.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooPickerView ()

- (void)pickerViewInit;

@end

NS_ASSUME_NONNULL_END

@implementation ZooPickerView

- (void)pickerViewInit {
    self.overflow = YES;
    self.backgroundColor = UIColor.clearColor;
    self.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage zoo_xcassetImageNamed:@"zoo_visual"]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self pickerViewInit];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self pickerViewInit];
    }

    return self;
}

@end
