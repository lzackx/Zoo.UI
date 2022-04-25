//
//  ZooViewCheckManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooViewCheckManager.h"
#import "ZooViewCheckView.h"
#import "ZooDefine.h"


@interface ZooViewCheckManager()

@property (nonatomic, strong) ZooViewCheckView *viewCheckView;

@end

@implementation ZooViewCheckManager

+ (ZooViewCheckManager *)shareInstance{
    static dispatch_once_t once;
    static ZooViewCheckManager *instance;
    dispatch_once(&once, ^{
        instance = [[ZooViewCheckManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePlugin:) name:ZooClosePluginNotification object:nil];
        [[ZooUtil getKeyWindow] addObserver:self forKeyPath:@"rootViewController" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [[ZooUtil getKeyWindow] removeObserver:self forKeyPath:@"rootViewController"];
}

- (void)show{
    if (!_viewCheckView) {
        _viewCheckView = [[ZooViewCheckView alloc] init];
        _viewCheckView.hidden = YES;
        [[ZooUtil getKeyWindow] addSubview:_viewCheckView];
    }
    [_viewCheckView show];
}

- (void)hidden{
    [_viewCheckView hide];
}

- (void)closePlugin:(NSNotification *)notification{
    [self hidden];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [[ZooUtil getKeyWindow] bringSubviewToFront:self.viewCheckView];
}

@end
