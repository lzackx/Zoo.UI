//
//  ZooColorPickView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooColorPickView.h"
#import "UIView+Zoo.h"
#import "UIImage+Zoo.h"
#import "UIColor+Zoo.h"

@interface ZooColorPickView()

@property (nonatomic, strong) UIImageView *circleView;
@property (nonatomic, strong) UILabel *colorLabel;

@end

@implementation ZooColorPickView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _circleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.zoo_width, self.zoo_height)];
        _circleView.layer.masksToBounds = YES;
        _circleView.layer.cornerRadius = self.zoo_width/2;
        _circleView.layer.borderWidth = 5;
        _circleView.layer.borderColor = [UIColor clearColor].CGColor;
        [self addSubview:_circleView];
        
        UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.zoo_left-0.5, self.zoo_top-0.5, self.zoo_width+1, self.zoo_height+1)];
        CAShapeLayer *layer1 = [CAShapeLayer layer];
        layer1.lineWidth = 1;
        layer1.strokeColor = [UIColor lightGrayColor].CGColor;
        layer1.fillColor = [UIColor clearColor].CGColor;
        layer1.path = path1.CGPath;
        [self.layer addSublayer:layer1];
        
        UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.zoo_left+5, self.zoo_top+5, self.zoo_width-10, self.zoo_height-10)];
        CAShapeLayer *layer2 = [CAShapeLayer layer];
        layer2.lineWidth = 1;
        layer2.strokeColor = [UIColor lightGrayColor].CGColor;
        layer2.fillColor = [UIColor clearColor].CGColor;
        layer2.path = path2.CGPath;
        [self.layer addSublayer:layer2];
        
        UIView *pointView = [[UIView alloc] init];
        pointView.zoo_size = CGSizeMake(6, 6);
        pointView.center = self.center;
        pointView.backgroundColor = [UIColor blackColor];
        pointView.layer.cornerRadius = 1.5;
        [self addSubview:pointView];
        
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.zoo_width, 12)];
        colorLabel.backgroundColor = [UIColor clearColor];
        colorLabel.font = [UIFont systemFontOfSize:12];
        colorLabel.textColor = [UIColor blackColor];
        colorLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:colorLabel];
        self.colorLabel = colorLabel;
    }
    return self;
}

- (void)setCurrentImage:(UIImage *)image{
    _circleView.image = image;
}

- (void)setCurrentColor:(NSString *)hexColor{
    _circleView.layer.borderColor = [UIColor zoo_colorWithHexString:hexColor].CGColor;
    _colorLabel.text = hexColor;
}

@end
