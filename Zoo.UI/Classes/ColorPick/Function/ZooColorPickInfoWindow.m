//
//  ZooColorPickInfoWindow.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooColorPickInfoWindow.h"
#import "ZooColorPickInfoView.h"
#import <Zoo/ZooDefine.h>

@interface ZooColorPickInfoController: UIViewController

@end

@implementation ZooColorPickInfoController
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.window.frame = CGRectMake(kZooSizeFrom750_Landscape(30), ZooScreenHeight - (size.height < size.width ? size.height : size.width) - kZooSizeFrom750_Landscape(30), size.height, size.width);
    });
}
@end

@interface ZooColorPickInfoWindow () <ZooColorPickInfoViewDelegate>

@property (nonatomic, strong) ZooColorPickInfoView *pickInfoView;

@end

@implementation ZooColorPickInfoWindow

#pragma mark - Lifecycle

+ (ZooColorPickInfoWindow *)shareInstance{
    static dispatch_once_t once;
    static ZooColorPickInfoWindow *instance;
    dispatch_once(&once, ^{
        instance = [[ZooColorPickInfoWindow alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    if (kInterfaceOrientationPortrait) {
        self = [super initWithFrame:CGRectMake(kZooSizeFrom750_Landscape(30), ZooScreenHeight - kZooSizeFrom750_Landscape(100) - kZooSizeFrom750_Landscape(30) - IPHONE_SAFEBOTTOMAREA_HEIGHT, ZooScreenWidth - 2*kZooSizeFrom750_Landscape(30), kZooSizeFrom750_Landscape(100))];
    } else {
        self = [super initWithFrame:CGRectMake(kZooSizeFrom750_Landscape(30), ZooScreenHeight - kZooSizeFrom750_Landscape(100) - kZooSizeFrom750_Landscape(30) - IPHONE_SAFEBOTTOMAREA_HEIGHT, ZooScreenHeight - 2*kZooSizeFrom750_Landscape(30), kZooSizeFrom750_Landscape(100))];
    }
    
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
        self.windowLevel = UIWindowLevelAlert;
        if (!self.rootViewController) {
            self.rootViewController = [[ZooColorPickInfoController alloc] init];
        }
        
        ZooColorPickInfoView *pickInfoView = [[ZooColorPickInfoView alloc] initWithFrame:self.bounds];
        pickInfoView.delegate = self;
        [self.rootViewController.view addSubview:pickInfoView];
        self.pickInfoView = pickInfoView;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePlugin:) name:ZooClosePluginNotification object:nil];
    }
    return self;
}

#pragma mark - Public

- (void)show{
    self.hidden = NO;
}

- (void)hide{
    self.hidden = YES;
}

- (void)setCurrentColor:(NSString *)hexColor {
    [self.pickInfoView setCurrentColor:hexColor];
}

#pragma mark - Actions

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
}
 
#pragma mark ZooColorPickInfoViewDelegate

- (void)closeBtnClicked:(id)sender onColorPickInfoView:(ZooColorPickInfoView *)colorPickInfoView {
    [[NSNotificationCenter defaultCenter] postNotificationName:ZooClosePluginNotification object:nil userInfo:nil];
}

#pragma mark - Notification

- (void)closePlugin:(NSNotification *)notification{
    [self hide];
}


@end
