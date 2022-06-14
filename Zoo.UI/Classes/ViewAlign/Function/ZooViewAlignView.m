//
//  ZooViewAlignView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooViewAlignView.h"
#import <Zoo/ZooDefine.h>
#import <Zoo/ZooVisualInfoWindow.h>

#define ALIGN_COLOR @"#FF0000"

static CGFloat const kViewCheckSize = 62;

@interface ZooViewAlignView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *horizontalLine;//水平线
@property (nonatomic, strong) UIView *verticalLine;//垂直线
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) ZooVisualInfoWindow *infoWindow; 

@end



@implementation ZooViewAlignView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ZooScreenWidth, ZooScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        self.layer.zPosition = FLT_MAX;
        //self.userInteractionEnabled = NO;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ZooScreenWidth/2-kViewCheckSize/2, ZooScreenHeight/2-kViewCheckSize/2, kViewCheckSize, kViewCheckSize)];
        imageView.image = [UIImage zoo_xcassetImageNamed:@"zoo_visual"];
        [self addSubview:imageView];
        _imageView = imageView;
        
        imageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [imageView addGestureRecognizer:pan];
        
        _horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.zoo_centerY-0.25, self.zoo_width, 0.5)];
        _horizontalLine.backgroundColor = [UIColor zoo_colorWithHexString:ALIGN_COLOR];
        [self addSubview:_horizontalLine];
        
        _verticalLine = [[UIView alloc] initWithFrame:CGRectMake(imageView.zoo_centerX-0.25, 0, 0.5, self.zoo_height)];
        _verticalLine.backgroundColor = [UIColor zoo_colorWithHexString:ALIGN_COLOR];
        [self addSubview:_verticalLine];
        
        [self bringSubviewToFront:_imageView];
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:12];
        _leftLabel.textColor = [UIColor zoo_colorWithHexString:ALIGN_COLOR];
        _leftLabel.text = [NSString stringWithFormat:@"%.1f",imageView.zoo_centerX];
        [self addSubview:_leftLabel];
        [_leftLabel sizeToFit];
        _leftLabel.frame = CGRectMake(imageView.zoo_centerX/2, imageView.zoo_centerY-_leftLabel.zoo_height, _leftLabel.zoo_width, _leftLabel.zoo_height);
        
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:12];
        _topLabel.textColor = [UIColor zoo_colorWithHexString:ALIGN_COLOR];
        _topLabel.text = [NSString stringWithFormat:@"%.1f",imageView.zoo_centerY];
        [self addSubview:_topLabel];
        [_topLabel sizeToFit];
        _topLabel.frame = CGRectMake(imageView.zoo_centerX-_topLabel.zoo_width, imageView.zoo_centerY/2, _topLabel.zoo_width, _topLabel.zoo_height);
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textColor = [UIColor zoo_colorWithHexString:ALIGN_COLOR];
        _rightLabel.text = [NSString stringWithFormat:@"%.1f",self.zoo_width-imageView.zoo_centerX];
        [self addSubview:_rightLabel];
        [_rightLabel sizeToFit];
        _rightLabel.frame = CGRectMake(imageView.zoo_centerX+(self.zoo_width-imageView.zoo_centerX)/2, imageView.zoo_centerY-_rightLabel.zoo_height, _rightLabel.zoo_width, _rightLabel.zoo_height);
        
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textColor = [UIColor zoo_colorWithHexString:ALIGN_COLOR];
        _bottomLabel.text = [NSString stringWithFormat:@"%.1f",self.zoo_height - imageView.zoo_centerY];
        [self addSubview:_bottomLabel];
        [_bottomLabel sizeToFit];
        _bottomLabel.frame = CGRectMake(imageView.zoo_centerX-_bottomLabel.zoo_width, imageView.zoo_centerY+(self.zoo_height - imageView.zoo_centerY)/2, _bottomLabel.zoo_width, _bottomLabel.zoo_height);
        
        CGRect infoWindowFrame = CGRectZero;
        if (kInterfaceOrientationPortrait) {
            infoWindowFrame = CGRectMake(kZooSizeFrom750_Landscape(30), ZooScreenHeight - kZooSizeFrom750_Landscape(100) - kZooSizeFrom750_Landscape(30), ZooScreenWidth - 2*kZooSizeFrom750_Landscape(30), kZooSizeFrom750_Landscape(100));
        } else {
            infoWindowFrame = CGRectMake(kZooSizeFrom750_Landscape(30), ZooScreenHeight - kZooSizeFrom750_Landscape(100) - kZooSizeFrom750_Landscape(30), ZooScreenHeight - 2*kZooSizeFrom750_Landscape(30), kZooSizeFrom750_Landscape(100));
        } 
        _infoWindow = [[ZooVisualInfoWindow alloc] initWithFrame:infoWindowFrame];
        
        
         [self configInfoLblText];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)sender{
    //1、获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    //2、清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    //3、重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.zoo_centerX+offsetPoint.x;
    CGFloat newY = panView.zoo_centerY+offsetPoint.y;

    CGPoint centerPoint = CGPointMake(newX, newY);
    panView.center = centerPoint;
    
    _horizontalLine.frame = CGRectMake(0, _imageView.zoo_centerY-0.25, self.zoo_width, 0.5);
    _verticalLine.frame = CGRectMake(_imageView.zoo_centerX-0.25, 0, 0.5, self.zoo_height);
    
    _leftLabel.text = [NSString stringWithFormat:@"%.1f",_imageView.zoo_centerX];
    [_leftLabel sizeToFit];
    _leftLabel.frame = CGRectMake(_imageView.zoo_centerX/2, _imageView.zoo_centerY-_leftLabel.zoo_height, _leftLabel.zoo_width, _leftLabel.zoo_height);
    
    _topLabel.text = [NSString stringWithFormat:@"%.1f",_imageView.zoo_centerY];
    [_topLabel sizeToFit];
    _topLabel.frame = CGRectMake(_imageView.zoo_centerX-_topLabel.zoo_width, _imageView.zoo_centerY/2, _topLabel.zoo_width, _topLabel.zoo_height);
    
    _rightLabel.text = [NSString stringWithFormat:@"%.1f",self.zoo_width-_imageView.zoo_centerX];
    [_rightLabel sizeToFit];
    _rightLabel.frame = CGRectMake(_imageView.zoo_centerX+(self.zoo_width-_imageView.zoo_centerX)/2, _imageView.zoo_centerY-_rightLabel.zoo_height, _rightLabel.zoo_width, _rightLabel.zoo_height);
    
    _bottomLabel.text = [NSString stringWithFormat:@"%.1f",self.zoo_height - _imageView.zoo_centerY];
    [_bottomLabel sizeToFit];
    _bottomLabel.frame = CGRectMake(_imageView.zoo_centerX-_bottomLabel.zoo_width, _imageView.zoo_centerY+(self.zoo_height - _imageView.zoo_centerY)/2, _bottomLabel.zoo_width, _bottomLabel.zoo_height);
    
    [self configInfoLblText];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if(CGRectContainsPoint(_imageView.frame, point)){
        return YES;
    }
    return NO;
}

- (void)configInfoLblText {
    _infoWindow.infoText = [NSString stringWithFormat:ZooLocalizedString(@"位置：左%@  右%@  上%@  下%@"), _leftLabel.text, _rightLabel.text, _topLabel.text, _bottomLabel.text];
}
 

- (void)show {
    _infoWindow.hidden = NO;
    self.hidden = NO;
}

- (void)hide {
    _infoWindow.hidden = YES;
    self.hidden = YES;
}

@end
