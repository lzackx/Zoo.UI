//
//  ZooColorPickMagnifyLayer.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN
typedef NSString* _Nullable (^ZooColorPickMagnifyLayerPointColorBlock) (CGPoint point);

@interface ZooColorPickMagnifyLayer : CALayer

/**
 获取指定点的颜色值
 */
@property (nonatomic, copy) ZooColorPickMagnifyLayerPointColorBlock pointColorBlock;

/**
 目标视图展示位置
 */
@property (nonatomic, assign) CGPoint targetPoint;

@end

NS_ASSUME_NONNULL_END
