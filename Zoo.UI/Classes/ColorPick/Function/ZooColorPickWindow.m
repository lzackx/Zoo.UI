//
//  ZooColorPickWindow.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooColorPickWindow.h"
#import <Zoo/UIView+Zoo.h>
#import <Zoo/ZooDefine.h>
#import "ZooColorPickView.h"
#import <Zoo/UIImage+Zoo.h>
#import <Zoo/ZooDefine.h>
#import <Zoo/UIColor+Zoo.h>
#import <Zoo/ZooDefine.h>
#import "ZooColorPickInfoWindow.h"
#import "ZooColorPickMagnifyLayer.h"

static CGFloat const kColorPickWindowSize = 150;

@interface ZooColorPickWindow()

// 这里先屏蔽掉，先使用layer自带的圆圈
//@property (nonatomic, strong) ZooColorPickView *colorPickView;

@property (nonatomic, strong) ZooColorPickMagnifyLayer *magnifyLayer;

@property (nonatomic, strong) UIImage *screenShotImage;

@end

@implementation ZooColorPickWindow

#pragma mark - Lifecycle

+ (ZooColorPickWindow *)shareInstance {
    static dispatch_once_t once;
    static ZooColorPickWindow *instance;
    dispatch_once(&once, ^{
        instance = [[ZooColorPickWindow alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(ZooScreenWidth/2-kColorPickWindowSize/2, ZooScreenHeight/2-kColorPickWindowSize/2, kColorPickWindowSize, kColorPickWindowSize)];
    if (self) {
        #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes){
                    if (windowScene.activationState == UISceneActivationStateForegroundActive){
                        self.windowScene = windowScene;
                        break;
                    }
                }
            }
        #endif
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 1.f;
        if (!self.rootViewController) {
            self.rootViewController = [[UIViewController alloc] init];
        }
        
        //        ZooColorPickView *colorPickView = [[ZooColorPickView alloc] initWithFrame:self.bounds];
        //        colorPickView.backgroundColor = [UIColor clearColor];
        //        [self.rootViewController.view addSubview:colorPickView];
        //        self.colorPickView = colorPickView;
        
        self.magnifyLayer.frame = self.bounds;
        __weak __typeof(self)weakSelf = self;
        self.magnifyLayer.pointColorBlock = ^(CGPoint currentPoint) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            return [strongSelf colorAtPoint:currentPoint];
        };
        [self.layer addSublayer:self.magnifyLayer];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePlugin:) name:ZooClosePluginNotification object:nil];
        
        //        NSString *hexColor = [self getColorWithCenterPoint:self.center];
        //    [self.colorPickView setCurrentColor:hexColor];
        //        [[ZooColorPickInfoWindow shareInstance] setCurrentColor:hexColor];
    }
    return self;
}

#pragma mark - Public

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

- (NSString *)colorAtPoint:(CGPoint)point {
    return [self colorAtPoint:point inImage:self.screenShotImage];
}

#pragma mark - Private

- (void)updateScreeShotImage {
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [[ZooUtil getKeyWindow].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.screenShotImage = image;
}

- (NSString *)colorAtPoint:(CGPoint)point inImage:(UIImage *)image {
    // Cancel if point is outside image coordinates
    if (!image || !CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    NSString *hexColor = [NSString stringWithFormat:@"#%02x%02x%02x",pixelData[0],pixelData[1],pixelData[2]];
    return hexColor;
}

#pragma mark - Actions

- (void)pan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 开始拖动的时候更新屏幕快照
        [self updateScreeShotImage];
    }
    
    //1、获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    //2、清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    //3、重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.zoo_centerX+offsetPoint.x;
    CGFloat newY = panView.zoo_centerY+offsetPoint.y;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGPoint centerPoint = CGPointMake(newX, newY);
    panView.center = centerPoint;
    
    self.magnifyLayer.targetPoint = centerPoint;
    
    // update positions
    //    self.magnifyLayer.position = centerPoint;
    
    // Make magnifyLayer sharp on screen
    CGRect magnifyFrame     = self.magnifyLayer.frame;
    magnifyFrame.origin     = CGPointMake(round(magnifyFrame.origin.x), round(magnifyFrame.origin.y));
    self.magnifyLayer.frame = magnifyFrame;
    [self.magnifyLayer setNeedsDisplay];
    
    [CATransaction commit];
    
    NSString *hexColor = [self colorAtPoint:centerPoint];
    [[ZooColorPickInfoWindow shareInstance] setCurrentColor:hexColor];
}

#pragma mark - Notification

- (void)closePlugin:(NSNotification *)notification{
    self.hidden = YES;
}

#pragma mark - Getter

- (ZooColorPickMagnifyLayer *)magnifyLayer {
    if (!_magnifyLayer) {
        _magnifyLayer = [ZooColorPickMagnifyLayer layer];
        _magnifyLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return _magnifyLayer;
}

@end
