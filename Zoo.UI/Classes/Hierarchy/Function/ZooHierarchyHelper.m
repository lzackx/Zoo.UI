//
//  ZooHierarchyHelper.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooHierarchyHelper.h"

static ZooHierarchyHelper *_instance = nil;

@implementation ZooHierarchyHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZooHierarchyHelper alloc] init];
    });
    return _instance;
}

- (NSArray <UIWindow *>*)allWindows {
    return [self allWindowsIgnorePrefix:nil];
}

- (NSArray <UIWindow *>*)allWindowsIgnorePrefix:(NSString *_Nullable)prefix {
    BOOL includeInternalWindows = YES;
    BOOL onlyVisibleWindows = NO;
    
    SEL allWindowsSelector = NSSelectorFromString(@"allWindowsIncludingInternalWindows:onlyVisibleWindows:");
    
    NSMethodSignature *methodSignature = [[UIWindow class] methodSignatureForSelector:allWindowsSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    invocation.target = [UIWindow class];
    invocation.selector = allWindowsSelector;
    [invocation setArgument:&includeInternalWindows atIndex:2];
    [invocation setArgument:&onlyVisibleWindows atIndex:3];
    [invocation invoke];
    
    __unsafe_unretained NSArray<UIWindow *> *windows = nil;
    [invocation getReturnValue:&windows];
    
    windows = [windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow * obj1, UIWindow * obj2) {
        return obj1.windowLevel > obj2.windowLevel;
    }];
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:windows];
    NSMutableArray *removeResults = [[NSMutableArray alloc] init];
    if ([prefix length] > 0) {
        for (UIWindow *window in results) {
            if ([NSStringFromClass(window.class) hasPrefix:prefix]) {
                [removeResults addObject:window];
            }            
        }
    }
    [results removeObjectsInArray:removeResults];
    
    return [NSArray arrayWithArray:results];
}

@end
