//
//  NSObject+ZooHierarchy.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "NSObject+ZooHierarchy.h"
#import "UIViewController+ZooHierarchy.h"
#import "ZooHierarchyFormatterTool.h"
#import "ZooHierarchyCategoryModel.h"
#import "ZooHierarchyCellModel.h"
#import "UIColor+ZooHierarchy.h"
#import "ZooEnumDescription.h"
#import "ZooHierarchyHelper.h"
#import <Zoo/UIColor+Zoo.h>
#import <Zoo/ZooDefine.h>

NSNotificationName const ZooHierarchyChangeNotificationName = @"ZooHierarchyChangeNotificationName";

@implementation NSObject (ZooHierarchy)

#pragma mark - Public
- (NSArray <ZooHierarchyCategoryModel *>*)zoo_hierarchyCategoryModels {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Class Name" detailTitle:NSStringFromClass(self.class)] noneInsets];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Address" detailTitle:[NSString stringWithFormat:@"%p",self]] noneInsets];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Description" detailTitle:self.description] noneInsets];
    [settings addObject:model3];
    
    return @[[[ZooHierarchyCategoryModel alloc] initWithTitle:@"Object" items:settings]];
}

- (void)zoo_showIntAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@",[self valueForKeyPath:keyPath]] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:@([newText integerValue]) forKeyPath:keyPath];
    }];
}

- (void)zoo_showFrameAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:NSStringFromCGRect([value CGRectValue]) handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[NSValue valueWithCGRect:[weakSelf zoo_rectFromString:newText originalRect:[value CGRectValue]]] forKeyPath:keyPath];
    }];
}

- (void)zoo_showColorAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block UIColor *color = [self valueForKeyPath:keyPath];
    if (color && ![color isKindOfClass:[UIColor class]]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:[color zoo_HexString] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[weakSelf zoo_colorFromString:newText originalColor:color] forKeyPath:keyPath];
    }];
}

- (void)zoo_showFontAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block UIFont *font = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:[ZooHierarchyFormatterTool formatNumber:@(font.pointSize)] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[font fontWithSize:[newText doubleValue]] forKeyPath:keyPath];
    }];
}

- (UIColor *)zoo_hashColor {
    CGFloat hue = ((self.hash >> 4) % 256) / 255.0;
    return [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

#pragma mark - Primary
- (NSString *)zoo_hierarchyColorDescription:(UIColor *_Nullable)color {
    if (!color) {
        return @"<nil color>";
    }
    
    CGFloat r = [color red];
    CGFloat g = [color green];
    CGFloat b = [color blue];
    CGFloat a = [color alpha];
    NSString *rgb = [NSString stringWithFormat:@"R:%@ G:%@ B:%@ A:%@", [ZooHierarchyFormatterTool formatNumber:@(r)], [ZooHierarchyFormatterTool formatNumber:@(g)], [ZooHierarchyFormatterTool formatNumber:@(b)], [ZooHierarchyFormatterTool formatNumber:@(a)]];
    
    NSString *colorName = [color zoo_systemColorName];
    
    return colorName ? [rgb stringByAppendingFormat:@"\n%@",colorName] : [rgb stringByAppendingFormat:@"\n%@",[color zoo_HexString]];
}

- (UIColor *)zoo_colorFromString:(NSString *)string originalColor:(UIColor *)color {
    UIColor *newColor = [UIColor zoo_colorWithHexString:string];
    if (!newColor) {
        return color;
    }
    return newColor;
}

- (NSString *)zoo_hierarchyBoolDescription:(BOOL)flag {
    return flag ? @"On" : @"Off";
}

- (NSString *)zoo_hierarchyImageDescription:(UIImage *)image {
    return image ? image.description : @"No image";
}

- (NSString *)zoo_hierarchyObjectDescription:(NSObject *)obj {
    NSString *text = @"<null>";
    if (obj) {
        text = [NSString stringWithFormat:@"%@",obj];
    }
    if ([text length] == 0) {
        text = @"<empty string>";
    }
    return text;
}

- (NSString *)zoo_hierarchyDateDescription:(NSDate *)date {
    if (!date) {
        return @"<null>";
    }
    return [ZooHierarchyFormatterTool stringFromDate:date] ?: @"<null>";
}

- (NSString *)zoo_hierarchyTextDescription:(NSString *)text {
    if (text == nil) {
        return @"<nil>";
    }
    if ([text length] == 0) {
        return @"<empty string>";
    }
    return text;
}

- (NSString *)zoo_hierarchyPointDescription:(CGPoint)point {
    return [NSString stringWithFormat:@"X: %@   Y: %@",[ZooHierarchyFormatterTool formatNumber:@(point.x)],[ZooHierarchyFormatterTool formatNumber:@(point.y)]];
}

- (CGPoint)zoo_pointFromString:(NSString *)string orginalPoint:(CGPoint)point {
    CGPoint newPoint = CGPointFromString(string);
    return newPoint;
}

- (NSString *)zoo_hierarchySizeDescription:(CGSize)size {
    return [NSString stringWithFormat:@"W: %@   H: %@",[ZooHierarchyFormatterTool formatNumber:@(size.width)], [ZooHierarchyFormatterTool formatNumber:@(size.height)]];
}

- (CGRect)zoo_rectFromString:(NSString *)string originalRect:(CGRect)rect {
    CGRect newRect = CGRectFromString(string);
    if (CGRectEqualToRect(newRect, CGRectZero) && ![string isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        // Wrong text.
        return rect;
    }
    return newRect;
}

- (CGSize)zoo_sizeFromString:(NSString *)string originalSize:(CGSize)size {
    CGSize newSize = CGSizeFromString(string);
    if (CGSizeEqualToSize(newSize, CGSizeZero) && ![string isEqualToString:NSStringFromCGSize(CGSizeZero)]) {
        // Wrong text.
        return size;
    }
    return newSize;
}

- (NSString *)zoo_hierarchyInsetsTopBottomDescription:(UIEdgeInsets)insets {
    return [NSString stringWithFormat:@"top %@    bottom %@",[ZooHierarchyFormatterTool formatNumber:@(insets.top)], [ZooHierarchyFormatterTool formatNumber:@(insets.bottom)]];
}

- (UIEdgeInsets)zoo_insetsFromString:(NSString *)string originalInsets:(UIEdgeInsets)insets {
    UIEdgeInsets newInsets = UIEdgeInsetsFromString(string);
    if (UIEdgeInsetsEqualToEdgeInsets(newInsets, UIEdgeInsetsZero) && ![string isEqualToString:NSStringFromUIEdgeInsets(UIEdgeInsetsZero)]) {
        // Wrong text.
        return insets;
    }
    return newInsets;
}

- (NSString *)zoo_hierarchyInsetsLeftRightDescription:(UIEdgeInsets)insets {
    return [NSString stringWithFormat:@"left %@    right %@",[ZooHierarchyFormatterTool formatNumber:@(insets.left)], [ZooHierarchyFormatterTool formatNumber:@(insets.right)]];
}

- (NSString *)zoo_hierarchyOffsetDescription:(UIOffset)offset {
    return [NSString stringWithFormat:@"h %@   v %@",[ZooHierarchyFormatterTool formatNumber:@(offset.horizontal)], [ZooHierarchyFormatterTool formatNumber:@(offset.vertical)]];
}

- (void)zoo_showDoubleAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:[ZooHierarchyFormatterTool formatNumber:[self valueForKeyPath:keyPath]] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:@([newText doubleValue]) forKeyPath:keyPath];
    }];
}

- (void)zoo_showPointAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:NSStringFromCGPoint([value CGPointValue]) handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[NSValue valueWithCGPoint:[weakSelf zoo_pointFromString:newText orginalPoint:[value CGPointValue]]] forKeyPath:keyPath];
    }];
}

- (void)zoo_showEdgeInsetsAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:NSStringFromUIEdgeInsets([value UIEdgeInsetsValue]) handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[NSValue valueWithUIEdgeInsets:[weakSelf zoo_insetsFromString:newText originalInsets:[value UIEdgeInsetsValue]]] forKeyPath:keyPath];
    }];
}

- (void)zoo_showTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:[self valueForKeyPath:keyPath] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:newText forKeyPath:keyPath];
    }];
}

- (void)zoo_showAttributeTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSAttributedString *attribute = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:attribute.string handler:^(NSString * _Nullable newText) {
        NSMutableAttributedString *mutAttribute = [[NSMutableAttributedString alloc] initWithAttributedString:attribute];
        [mutAttribute replaceCharactersInRange:NSMakeRange(0, attribute.string.length) withString:newText];
        [weakSelf setValue:[mutAttribute copy] forKeyPath:keyPath];
    }];
}

- (void)zoo_showSizeAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:NSStringFromCGSize([value CGSizeValue]) handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[NSValue valueWithCGSize:[weakSelf zoo_sizeFromString:newText originalSize:[value CGSizeValue]]] forKeyPath:keyPath];
    }];
}

- (void)zoo_showDateAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    NSDate *date = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self zoo_showTextFieldAlertWithText:[ZooHierarchyFormatterTool stringFromDate:date] handler:^(NSString * _Nullable newText) {
        NSDate *newDate = [ZooHierarchyFormatterTool dateFromString:newText];
        if (newDate) {
            [weakSelf setValue:newDate forKeyPath:keyPath];
        }
    }];
}

- (void)zoo_showTextFieldAlertWithText:(NSString *)text handler:(nullable void (^)(NSString * _Nullable newText))handler {
    __weak typeof(self) weakSelf = self;
    UIWindow *window = (UIWindow *)[ZooHierarchyHelper shared].window;
    [window.rootViewController.zoo_currentShowingViewController zoo_showTextFieldAlertControllerWithMessage:@"Change Property" text:text handler:^(NSString * _Nullable newText) {
        if (handler) {
            handler(newText);
        }
        [weakSelf zoo_postHierarchyChangeNotification];
    }];
}

- (void)zoo_showActionSheetWithActions:(NSArray *)actions currentAction:(NSString *)currentAction completion:(void (^)(NSInteger index))completion {
    __weak typeof(self) weakSelf = self;
    UIWindow *window = (UIWindow *)[ZooHierarchyHelper shared].window;
    [window.rootViewController.zoo_currentShowingViewController zoo_showActionSheetWithTitle:@"Change Property" actions:actions currentAction:currentAction completion:^(NSInteger index) {
        if (completion) {
            completion(index);
        }
        [weakSelf zoo_postHierarchyChangeNotification];
    }];
}

- (void)zoo_postHierarchyChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:ZooHierarchyChangeNotificationName object:self];
}

- (void)zoo_replaceAttributeString:(NSString *)newString key:(NSString *)key {
    NSAttributedString *string = [self valueForKey:key];
    if (string && ![string isKindOfClass:[NSAttributedString class]]) {
        return;
    }
    NSMutableAttributedString *attribute = string ? [[NSMutableAttributedString alloc] initWithAttributedString:string] : [[NSMutableAttributedString alloc] init];
    [attribute replaceCharactersInRange:NSMakeRange(0, string.length) withString:newString];
    [self setValue:string forKey:key];
}

@end

@implementation UIView (ZooHierarchy)

#pragma mark - Public
- (NSArray <ZooHierarchyCategoryModel *>*)zoo_sizeHierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Frame" detailTitle:[self zoo_hierarchyPointDescription:self.frame.origin]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showFrameAlertAndAutomicSetWithKeyPath:@"frame"];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchySizeDescription:self.frame.size]] noneInsets];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Bounds" detailTitle:[self zoo_hierarchyPointDescription:self.bounds.origin]] noneInsets];
    model3.block = ^{
        [weakSelf zoo_showFrameAlertAndAutomicSetWithKeyPath:@"bounds"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchySizeDescription:self.bounds.size]] noneInsets];
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Center" detailTitle:[self zoo_hierarchyPointDescription:self.center]] noneInsets];
    model5.block = ^{
        [weakSelf zoo_showPointAlertAndAutomicSetWithKeyPath:@"center"];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Position" detailTitle:[self zoo_hierarchyPointDescription:self.layer.position]] noneInsets];
    model6.block = ^{
        [weakSelf zoo_showPointAlertAndAutomicSetWithKeyPath:@"layer.position"];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Z Position" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.layer.zPosition)]];
    model7.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"layer.zPosition"];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Anchor Point" detailTitle:[self zoo_hierarchyPointDescription:self.layer.anchorPoint]] noneInsets];
    model8.block = ^{
        [weakSelf zoo_showPointAlertAndAutomicSetWithKeyPath:@"layer.anchorPoint"];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Anchor Point Z" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.layer.anchorPointZ)]];
    model9.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"layer.anchorPointZ"];
    };
    [settings addObject:model9];

    ZooHierarchyCellModel *lastConstrainModel = nil;
    
    for (NSLayoutConstraint *constrain in self.constraints) {
        if (!constrain.shouldBeArchived) {
            continue;
        }
        NSString *constrainDesc = [self zoo_hierarchyLayoutConstraintDescription:constrain];
        if (constrainDesc) {
            ZooHierarchyCellModel *mod = [[[ZooHierarchyCellModel alloc] initWithTitle:lastConstrainModel ? nil : @"Constrains" detailTitle:constrainDesc] noneInsets];
            __weak NSLayoutConstraint *cons = constrain;
            mod.block = ^{
                [weakSelf zoo_showTextFieldAlertWithText:[ZooHierarchyFormatterTool formatNumber:@(cons.constant)] handler:^(NSString * _Nullable newText) {
                    cons.constant = [newText doubleValue];
                    [weakSelf setNeedsLayout];
                }];
            };
            [settings addObject:mod];
            lastConstrainModel = mod;
        }
    }
    
    for (NSLayoutConstraint *constrain in self.superview.constraints) {
        if (!constrain.shouldBeArchived) {
            continue;
        }
        if (constrain.firstItem == self || constrain.secondItem == self) {
            NSString *constrainDesc = [self zoo_hierarchyLayoutConstraintDescription:constrain];
            if (constrainDesc) {
                ZooHierarchyCellModel *mod = [[[ZooHierarchyCellModel alloc] initWithTitle:lastConstrainModel ? nil : @"Constrains" detailTitle:constrainDesc] noneInsets];
                __weak NSLayoutConstraint *cons = constrain;
                mod.block = ^{
                    [weakSelf zoo_showTextFieldAlertWithText:[ZooHierarchyFormatterTool formatNumber:@(cons.constant)] handler:^(NSString * _Nullable newText) {
                        cons.constant = [newText doubleValue];
                        [weakSelf setNeedsLayout];
                    }];
                };
                [settings addObject:mod];
                lastConstrainModel = mod;
            }
        }
    }
    
    [lastConstrainModel normalInsets];
    
    return @[[[ZooHierarchyCategoryModel alloc] initWithTitle:@"View" items:settings]];
}

#pragma mark - Primary
- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Layer" detailTitle:self.layer.description] noneInsets];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Layer Class" detailTitle:NSStringFromClass(self.layer.class)];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Content Model" detailTitle:[ZooEnumDescription viewContentModeDescription:self.contentMode]] noneInsets];
    model3.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription viewContentModeDescriptions] currentAction:[ZooEnumDescription viewContentModeDescription:weakSelf.contentMode] completion:^(NSInteger index) {
            weakSelf.contentMode = index;
        }];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Tag" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.tag]];
    model4.block = ^{
        [weakSelf zoo_showIntAlertAndAutomicSetWithKeyPath:@"tag"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"User Interaction" flag: self.isUserInteractionEnabled] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.userInteractionEnabled = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Multiple Touch" flag:self.isMultipleTouchEnabled];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.multipleTouchEnabled = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Alpha" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.alpha)]] noneInsets];
    model7.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"alpha"];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Background" detailTitle:[self zoo_hierarchyColorDescription:self.backgroundColor]] noneInsets];
    model8.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"backgroundColor"];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Tint" detailTitle:[self zoo_hierarchyColorDescription:self.tintColor]];
    model9.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"tintColor"];
    };
    [settings addObject:model9];
    
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Drawing" detailTitle:@"Opaque" flag:self.isOpaque] noneInsets];
    model10.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.opaque = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model10];
    
    ZooHierarchyCellModel *model11 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Hidden" flag:self.isHidden] noneInsets];
    model11.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.hidden = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Clears Graphics Context" flag:self.clearsContextBeforeDrawing] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clearsContextBeforeDrawing = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    ZooHierarchyCellModel *model13 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Clip To Bounds" flag:self.clipsToBounds] noneInsets];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clipsToBounds = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    ZooHierarchyCellModel *model14 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Autoresizes Subviews" flag:self.autoresizesSubviews];
    model14.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.autoresizesSubviews = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model14];
    
    ZooHierarchyCellModel *model15 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Trait Collection" detailTitle:nil] noneInsets];
    [settings addObject:model15];
    
    if (@available(iOS 12.0, *)) {
        ZooHierarchyCellModel *model16 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[ZooEnumDescription userInterfaceStyleDescription:self.traitCollection.userInterfaceStyle]] noneInsets];
        [settings addObject:model16];
    }
    
    ZooHierarchyCellModel *model17 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[@"Vertical" stringByAppendingFormat:@" %@",[ZooEnumDescription userInterfaceSizeClassDescription:self.traitCollection.verticalSizeClass]]] noneInsets];
    [settings addObject:model17];
    
    ZooHierarchyCellModel *model18 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[@"Horizontal" stringByAppendingFormat:@" %@",[ZooEnumDescription userInterfaceSizeClassDescription:self.traitCollection.horizontalSizeClass]]] noneInsets];
    [settings addObject:model18];
    
    if (@available(iOS 10.0, *)) {
        ZooHierarchyCellModel *model19 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[ZooEnumDescription traitEnvironmentLayoutDirectionDescription:self.traitCollection.layoutDirection]];
        [settings addObject:model19];
    }
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"View" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

- (NSString *)zoo_hierarchyLayoutConstraintDescription:(NSLayoutConstraint *)constraint {
    NSMutableString *string = [[NSMutableString alloc] init];
    if (constraint.firstItem == self) {
        [string appendString:@"self."];
    } else if (constraint.firstItem == self.superview) {
        [string appendString:@"superview."];
    } else {
        [string appendFormat:@"%@.",NSStringFromClass([constraint.firstItem class])];
    }
    [string appendString:[ZooEnumDescription layoutAttributeDescription:constraint.firstAttribute]];
    [string appendString:[ZooEnumDescription layoutRelationDescription:constraint.relation]];
    if (constraint.secondItem) {
        if (constraint.secondItem == self) {
            [string appendString:@"self."];
        } else if (constraint.secondItem == self.superview) {
            [string appendString:@"superview."];
        } else {
            [string appendFormat:@"%@.",NSStringFromClass([constraint.secondItem class])];
        }
        [string appendString:[ZooEnumDescription layoutAttributeDescription:constraint.secondAttribute]];
        if (constraint.multiplier != 1) {
            [string appendFormat:@" * %@",[ZooHierarchyFormatterTool formatNumber:@(constraint.multiplier)]];
        }
        if (constraint.constant > 0) {
            [string appendFormat:@" + %@",[ZooHierarchyFormatterTool formatNumber:@(constraint.constant)]];
        } else if (constraint.constant < 0) {
            [string appendFormat:@" - %@",[ZooHierarchyFormatterTool formatNumber:@(fabs(constraint.constant))]];
        }
    } else if (constraint.constant) {
        [string appendString:[ZooHierarchyFormatterTool formatNumber:@(constraint.constant)]];
    } else {
        return nil;
    }
    
    [string appendFormat:@" @ %@",[ZooHierarchyFormatterTool formatNumber:@(constraint.priority)]];
    return string;
}

@end

@implementation UILabel (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Text" detailTitle:[self zoo_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:self.attributedText == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Text" detailTitle:[self zoo_hierarchyColorDescription:self.textColor]] noneInsets];
    model3.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchyObjectDescription:self.font]] noneInsets];
    model4.block = ^{
        [weakSelf zoo_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Aligned %@", [ZooEnumDescription textAlignmentDescription:self.textAlignment]]] noneInsets];
    model5.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAlignments] currentAction:[ZooEnumDescription textAlignmentDescription:weakSelf.textAlignment] completion:^(NSInteger index) {
            weakSelf.textAlignment = index;
        }];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Lines" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfLines]] noneInsets];
    model6.block = ^{
        [weakSelf zoo_showIntAlertAndAutomicSetWithKeyPath:@"numberOfLines"];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Enabled" flag:self.isEnabled] noneInsets];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enabled = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Highlighted" flag:self.isHighlighted];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Baseline" detailTitle:[NSString stringWithFormat:@"Align %@",[ZooEnumDescription baselineAdjustmentDescription:self.baselineAdjustment]]] noneInsets];
    model9.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription baselineAdjustments] currentAction:[ZooEnumDescription baselineAdjustmentDescription:weakSelf.baselineAdjustment] completion:^(NSInteger index) {
            weakSelf.baselineAdjustment = index;
        }];
    };
    [settings addObject:model9];
    
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Line Break" detailTitle:[ZooEnumDescription lineBreakModeDescription:self.lineBreakMode]] noneInsets];
    model10.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription lineBreaks] currentAction:[ZooEnumDescription lineBreakModeDescription:weakSelf.lineBreakMode] completion:^(NSInteger index) {
            weakSelf.lineBreakMode = index;
        }];
    };
    [settings addObject:model10];
    
    ZooHierarchyCellModel *model11 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Min Font Scale" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.minimumScaleFactor)]];
    model11.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumScaleFactor"];
    };
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Highlighted" detailTitle:[self zoo_hierarchyColorDescription:self.highlightedTextColor]] noneInsets];
    model12.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"highlightedTextColor"];
    };
    [settings addObject:model12];
    
    ZooHierarchyCellModel *model13 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self zoo_hierarchyColorDescription:self.shadowColor]] noneInsets];
    model13.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"shadowColor"];
    };
    [settings addObject:model13];
    
    ZooHierarchyCellModel *model14 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self zoo_hierarchySizeDescription:self.shadowOffset]];
    model14.block = ^{
        [weakSelf zoo_showSizeAlertAndAutomicSetWithKeyPath:@"shadowOffset"];
    };
    [settings addObject:model14];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Label" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIControl (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Alignment" detailTitle:[NSString stringWithFormat:@"%@ Horizonally", [ZooEnumDescription controlContentHorizontalAlignmentDescription:self.contentHorizontalAlignment]]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription controlContentHorizontalAlignments] currentAction:[ZooEnumDescription controlContentHorizontalAlignmentDescription:weakSelf.contentHorizontalAlignment] completion:^(NSInteger index) {
            weakSelf.contentHorizontalAlignment = index;
        }];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"%@ Vertically", [ZooEnumDescription controlContentVerticalAlignmentDescription:self.contentVerticalAlignment]]];
    model2.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription controlContentVerticalAlignments] currentAction:[ZooEnumDescription controlContentVerticalAlignmentDescription:weakSelf.contentVerticalAlignment] completion:^(NSInteger index) {
            weakSelf.contentVerticalAlignment = index;
        }];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Content" detailTitle:self.isSelected ? @"Selected" : @"Not Selected" flag:self.isSelected] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.selected = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:self.isEnabled ? @"Enabled" : @"Not Enabled" flag:self.isEnabled] noneInsets];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enabled = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted" flag:self.isHighlighted];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Control" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIButton (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Type" detailTitle:[ZooEnumDescription buttonTypeDescription:self.buttonType]];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"State" detailTitle:[ZooEnumDescription controlStateDescription:self.state]] noneInsets];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Title" detailTitle:[self zoo_hierarchyTextDescription:self.currentTitle]] noneInsets];
    model3.block = ^{
        [weakSelf zoo_showTextFieldAlertWithText:weakSelf.currentTitle handler:^(NSString * _Nullable newText) {
            [weakSelf setTitle:newText forState:weakSelf.state];
        }];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:self.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Text Color" detailTitle:[self zoo_hierarchyColorDescription:self.currentTitleColor]] noneInsets];
    model5.block = ^{
        [weakSelf zoo_showTextFieldAlertWithText:[weakSelf.currentTitleColor zoo_HexString] handler:^(NSString * _Nullable newText) {
            [weakSelf setTitleColor:[weakSelf zoo_colorFromString:newText originalColor:weakSelf.currentTitleColor] forState:weakSelf.state];
        }];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow Color" detailTitle:[self zoo_hierarchyColorDescription:self.currentTitleShadowColor]];
    model6.block = ^{
        [weakSelf zoo_showTextFieldAlertWithText:[weakSelf.currentTitleShadowColor zoo_HexString] handler:^(NSString * _Nullable newText) {
            [weakSelf setTitleShadowColor:[weakSelf zoo_colorFromString:newText originalColor:weakSelf.currentTitleShadowColor] forState:weakSelf.state];
        }];
    };
    [settings addObject:model6];
    
    id target = self.allTargets.allObjects.firstObject;
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Target" detailTitle:target ? [NSString stringWithFormat:@"%@",target] : @"<nil>"] noneInsets];
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Action" detailTitle:[self zoo_hierarchyTextDescription:[self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].firstObject]];;
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Image" detailTitle:[self zoo_hierarchyImageDescription:self.currentImage]];
    [settings addObject:model9];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self zoo_hierarchySizeDescription:self.titleShadowOffset]] noneInsets];
    model10.block = ^{
        [weakSelf zoo_showSizeAlertAndAutomicSetWithKeyPath:@"titleShadowOffset"];
    };
    [settings addObject:model10];
#pragma clang diagnostic pop
    
    ZooHierarchyCellModel *model11 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"On Highlight" detailTitle:self.reversesTitleShadowWhenHighlighted ? @"Shadow Reverses" : @"Normal Shadow"] noneInsets];
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:self.showsTouchWhenHighlighted ? @"Shows Touch" : @"Doesn't Show Touch"] noneInsets];
    [settings addObject:model12];
    
    ZooHierarchyCellModel *model13 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:self.adjustsImageWhenHighlighted ? @"Adjusts Image" : @"No Image Adjustment"] noneInsets];
    [settings addObject:model13];
    
    ZooHierarchyCellModel *model14 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"When Disabled" detailTitle:self.adjustsImageWhenDisabled ? @"Adjusts Image" : @"No Image Adjustment"] noneInsets];
    [settings addObject:model14];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ZooHierarchyCellModel *model15 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Line Break" detailTitle:[ZooEnumDescription lineBreakModeDescription:self.lineBreakMode]];
    [settings addObject:model15];
#pragma clang diagnostic pop
    
    ZooHierarchyCellModel *model16 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Content Insets" detailTitle:[self zoo_hierarchyInsetsTopBottomDescription:self.contentEdgeInsets]] noneInsets];
    model16.block = ^{
        [weakSelf zoo_showEdgeInsetsAndAutomicSetWithKeyPath:@"contentEdgeInsets"];
    };
    [settings addObject:model16];
    
    ZooHierarchyCellModel *model17 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchyInsetsLeftRightDescription:self.contentEdgeInsets]] noneInsets];
    [settings addObject:model17];
    
    ZooHierarchyCellModel *model18 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Title Insets" detailTitle:[self zoo_hierarchyInsetsTopBottomDescription:self.titleEdgeInsets]] noneInsets];
    model18.block = ^{
        [weakSelf zoo_showEdgeInsetsAndAutomicSetWithKeyPath:@"titleEdgeInsets"];
    };
    [settings addObject:model18];
    
    ZooHierarchyCellModel *model19 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchyInsetsLeftRightDescription:self.titleEdgeInsets]] noneInsets];
    [settings addObject:model19];
    
    ZooHierarchyCellModel *model20 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Image Insets" detailTitle:[self zoo_hierarchyInsetsTopBottomDescription:self.imageEdgeInsets]] noneInsets];
    model20.block = ^{
        [weakSelf zoo_showEdgeInsetsAndAutomicSetWithKeyPath:@"imageEdgeInsets"];
    };
    [settings addObject:model20];
    
    ZooHierarchyCellModel *model21 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchyInsetsLeftRightDescription:self.imageEdgeInsets]];
    [settings addObject:model21];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Button" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIImageView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Image" detailTitle: [self zoo_hierarchyImageDescription:self.image]];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Highlighted" detailTitle: [self zoo_hierarchyImageDescription:self.highlightedImage]];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[ZooHierarchyCellModel alloc] initWithTitle:@"State" detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted" flag:self.isHighlighted];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Image View" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITextField (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Plain Text" detailTitle:[self zoo_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Attributed Text" detailTitle:[self zoo_hierarchyObjectDescription:self.attributedText]] noneInsets];
    model2.block = ^{
        [weakSelf zoo_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedText"];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Allows Editing Attributes" flag:self.allowsEditingTextAttributes] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsEditingTextAttributes = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Color" detailTitle:[self zoo_hierarchyColorDescription:self.textColor]] noneInsets];
    model4.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Font" detailTitle:[self zoo_hierarchyObjectDescription:self.font]] noneInsets];
    model5.block = ^{
        [weakSelf zoo_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Alignment" detailTitle:[ZooEnumDescription textAlignmentDescription:self.textAlignment]] noneInsets];
    model6.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAlignments] currentAction:[ZooEnumDescription textAlignmentDescription:weakSelf.textAlignment] completion:^(NSInteger index) {
            weakSelf.textAlignment = index;
        }];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Placeholder" detailTitle:[self zoo_hierarchyTextDescription:self.placeholder ?: self.attributedPlaceholder.string]];
    model7.block = ^{
        if (weakSelf.placeholder) {
            [weakSelf zoo_showTextAlertAndAutomicSetWithKeyPath:@"placeholder"];
        } else {
            [weakSelf zoo_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedPlaceholder"];
        }
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Background" detailTitle: [self zoo_hierarchyImageDescription:self.background]] noneInsets];
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Disabled" detailTitle: [self zoo_hierarchyImageDescription:self.disabledBackground]];
    [settings addObject:model9];
    
    ZooHierarchyCellModel *model10 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Border Style" detailTitle:[ZooEnumDescription textBorderStyleDescription:self.borderStyle]];
    model10.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textBorderStyles] currentAction:[ZooEnumDescription textBorderStyleDescription:weakSelf.borderStyle] completion:^(NSInteger index) {
            weakSelf.borderStyle = index;
        }];
    };
    [settings addObject:model10];
    
    ZooHierarchyCellModel *model11 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Clear Button" detailTitle:[ZooEnumDescription textFieldViewModeDescription:self.clearButtonMode]] noneInsets];
    model11.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textFieldViewModes] currentAction:[ZooEnumDescription textFieldViewModeDescription:weakSelf.clearButtonMode] completion:^(NSInteger index) {
            weakSelf.clearButtonMode = index;
        }];
    };
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Clear when editing begins" flag:self.clearsOnBeginEditing];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clearsOnBeginEditing = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    ZooHierarchyCellModel *model13 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Min Font Size" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.minimumFontSize)]] noneInsets];
    model13.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumFontSize"];
    };
    [settings addObject:model13];
    
    ZooHierarchyCellModel *model14 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Adjusts to Fit" flag:self.adjustsFontSizeToFitWidth];
    model14.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.adjustsFontSizeToFitWidth = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model14];
    
    ZooHierarchyCellModel *model15 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Capitalization" detailTitle:[ZooEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model15.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAutocapitalizationTypes] currentAction:[ZooEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType] completion:^(NSInteger index) {
            weakSelf.autocapitalizationType = index;
        }];
    };
    [settings addObject:model15];
    
    ZooHierarchyCellModel *model16 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Correction" detailTitle:[ZooEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model16.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAutocorrectionTypes] currentAction:[ZooEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType] completion:^(NSInteger index) {
            weakSelf.autocorrectionType = index;
        }];
    };
    [settings addObject:model16];
    
    ZooHierarchyCellModel *model17 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[ZooEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    model17.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription keyboardTypes] currentAction:[ZooEnumDescription keyboardTypeDescription:weakSelf.keyboardType] completion:^(NSInteger index) {
            weakSelf.keyboardType = index;
        }];
    };
    [settings addObject:model17];
    
    ZooHierarchyCellModel *model18 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Appearance" detailTitle:[ZooEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    model18.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription keyboardAppearances] currentAction:[ZooEnumDescription keyboardAppearanceDescription:weakSelf.keyboardAppearance] completion:^(NSInteger index) {
            weakSelf.keyboardAppearance = index;
        }];
    };
    [settings addObject:model18];
    
    ZooHierarchyCellModel *model19 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Return Key" detailTitle:[ZooEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    model19.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription returnKeyTypes] currentAction:[ZooEnumDescription returnKeyTypeDescription:weakSelf.returnKeyType] completion:^(NSInteger index) {
            weakSelf.returnKeyType = index;
        }];
    };
    [settings addObject:model19];
    
    ZooHierarchyCellModel *model20 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Auto-enable Return Key" flag:self.enablesReturnKeyAutomatically] noneInsets];
    model20.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enablesReturnKeyAutomatically = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model20];
    
    ZooHierarchyCellModel *model21 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Secure Entry" flag:self.isSecureTextEntry];
    model21.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.secureTextEntry = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model21];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Text Field" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UISegmentedControl (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Behavior" detailTitle:self.isMomentary ? @"Momentary" : @"Persistent Selection" flag:self.isMomentary] noneInsets];
    model1.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.momentary = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Segments" detailTitle:[NSString stringWithFormat:@"%ld",(unsigned long)self.numberOfSegments]];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Selected Index" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.selectedSegmentIndex]] noneInsets];
    model3.block = ^{
        NSMutableArray *actions = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < weakSelf.numberOfSegments; i++) {
            [actions addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        [weakSelf zoo_showActionSheetWithActions:actions currentAction:[NSString stringWithFormat:@"%ld",(long)weakSelf.selectedSegmentIndex] completion:^(NSInteger index) {
            weakSelf.selectedSegmentIndex = index;
        }];
    };
    [settings addObject:model3];
    
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Large title" detailTitle:[self zoo_hierarchyTextDescription:self.largeContentTitle]] noneInsets];
        model4.block = ^{
            [weakSelf zoo_showTextAlertAndAutomicSetWithKeyPath:@"largeContentTitle"];
        };
        [settings addObject:model4];
        
        ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Image" detailTitle: [self zoo_hierarchyImageDescription:self.largeContentImage]] noneInsets];
        [settings addObject:model5];
    }
#endif
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Selected" detailTitle:[self isEnabledForSegmentAtIndex:self.selectedSegmentIndex] ? @"Enabled" : @"Not Enabled"];
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Offset" detailTitle:[self zoo_hierarchySizeDescription:[self contentOffsetForSegmentAtIndex:self.selectedSegmentIndex]]] noneInsets];
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Size Mode" detailTitle:self.apportionsSegmentWidthsByContent ? @"Proportional to Content" : @"Equal Widths" flag:self.apportionsSegmentWidthsByContent] noneInsets];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.apportionsSegmentWidthsByContent = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Width" detailTitle:[ZooHierarchyFormatterTool formatNumber:@([self widthForSegmentAtIndex:self.selectedSegmentIndex])]];
    [settings addObject:model9];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Segmented Control" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UISlider (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Current" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.value)]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"value"];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Minimum" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumValue"];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Maximum" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.maximumValue)]];
    model3.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumValue"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Min Image" detailTitle: [self zoo_hierarchyImageDescription:self.minimumValueImage]] noneInsets];
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Max Image" detailTitle: [self zoo_hierarchyImageDescription:self.maximumValueImage]];
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Min Track Tint" detailTitle:[self zoo_hierarchyColorDescription:self.minimumTrackTintColor]] noneInsets];
    model6.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"minimumTrackTintColor"];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Max Track Tint" detailTitle:[self zoo_hierarchyColorDescription:self.maximumTrackTintColor]] noneInsets];
    model7.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"maximumTrackTintColor"];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Thumb Tint" detailTitle:[self zoo_hierarchyColorDescription:self.tintColor]];
    model8.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"tintColor"];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Events" detailTitle:@"Continuous Update" flag:self.isContinuous];
    model9.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.continuous = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model9];
    
    ZooHierarchyCategoryModel *model =  [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Slider" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UISwitch (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"State" flag:self.isOn] noneInsets];
    model1.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.on = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"On Tint" detailTitle:[self zoo_hierarchyColorDescription:self.onTintColor]] noneInsets];
    model2.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"onTintColor"];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Thumb Tint" detailTitle:[self zoo_hierarchyColorDescription:self.thumbTintColor]];
    model3.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"thumbTintColor"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Switch" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIActivityIndicatorView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Style" detailTitle:[ZooEnumDescription activityIndicatorViewStyleDescription:self.activityIndicatorViewStyle]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription activityIndicatorViewStyles] currentAction:[ZooEnumDescription activityIndicatorViewStyleDescription:weakSelf.activityIndicatorViewStyle] completion:^(NSInteger index) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            if (index <= UIActivityIndicatorViewStyleGray) {
                weakSelf.activityIndicatorViewStyle = index;
            } else {
                #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
                if (@available(iOS 13.0, *)) {
                    weakSelf.activityIndicatorViewStyle = index + (UIActivityIndicatorViewStyleMedium - UIActivityIndicatorViewStyleGray - 1);
                }
                #endif
            }
#pragma clang diagnostic pop
        }];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Color" detailTitle:[self zoo_hierarchyColorDescription:self.color]] noneInsets];
    model2.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"color"];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Animating" flag:self.isAnimating] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            if (!weakSelf.isAnimating) {
                [weakSelf startAnimating];
            };
        } else {
            if (weakSelf.isAnimating) {
                [weakSelf stopAnimating];
            }
        }
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Hides When Stopped" flag:self.hidesWhenStopped];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.hidesWhenStopped = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Activity Indicator View" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIProgressView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Style" detailTitle:[ZooEnumDescription progressViewStyleDescription:self.progressViewStyle]];
    model1.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription progressViewStyles] currentAction:[ZooEnumDescription progressViewStyleDescription:weakSelf.progressViewStyle] completion:^(NSInteger index) {
            weakSelf.progressViewStyle = index;
        }];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Progress" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.progress)]];
    model2.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"progress"];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Progress Tint" detailTitle:[self zoo_hierarchyColorDescription:self.progressTintColor]] noneInsets];
    model3.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"progressTintColor"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Track Tint" detailTitle:[self zoo_hierarchyColorDescription:self.trackTintColor]];
    model4.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"trackTintColor"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Progress Image" detailTitle:[self zoo_hierarchyImageDescription:self.progressImage]] noneInsets];
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Track Image" detailTitle:[self zoo_hierarchyImageDescription:self.trackImage]];
    [settings addObject:model6];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Progress View" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIPageControl (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Pages" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfPages]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showIntAlertAndAutomicSetWithKeyPath:@"numberOfPages"];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Current Page" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.currentPage]] noneInsets];
    model2.block = ^{
        if (weakSelf.numberOfPages < 10) {
            NSMutableArray *actions = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < weakSelf.numberOfPages; i++) {
                [actions addObject:[NSString stringWithFormat:@"%ld",(long)i]];
            }
            [weakSelf zoo_showActionSheetWithActions:actions currentAction:[NSString stringWithFormat:@"%ld",(long)weakSelf.currentPage] completion:^(NSInteger index) {
                weakSelf.currentPage = index;
            }];
        } else {
            [weakSelf zoo_showIntAlertAndAutomicSetWithKeyPath:@"currentPage"];
        }
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Hides for Single Page" flag:self.hidesForSinglePage] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.hidesForSinglePage = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Defers Page Display" flag:self.defersCurrentPageDisplay];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.defersCurrentPageDisplay = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Tint Color" detailTitle:[self zoo_hierarchyColorDescription:self.pageIndicatorTintColor]] noneInsets];
    model5.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"pageIndicatorTintColor"];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Current Page" detailTitle:[self zoo_hierarchyColorDescription:self.currentPageIndicatorTintColor]];
    model6.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"currentPageIndicatorTintColor"];
    };
    [settings addObject:model6];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Page Control" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIStepper (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Value" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.value)]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"value"];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Minimum" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumValue"];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Maximum" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.maximumValue)]] noneInsets];
    model3.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumValue"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Step" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.stepValue)]];
    model4.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"stepValue"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Autorepeat" flag:self.autorepeat] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.autorepeat = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Continuous" flag:self.isContinuous] noneInsets];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.continuous = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Wrap" flag:self.wraps];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.wraps = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Stepper" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIScrollView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Style" detailTitle:[ZooEnumDescription scrollViewIndicatorStyleDescription:self.indicatorStyle]];
    model1.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription scrollViewIndicatorStyles] currentAction:[ZooEnumDescription scrollViewIndicatorStyleDescription:weakSelf.indicatorStyle] completion:^(NSInteger index) {
            weakSelf.indicatorStyle = index;
        }];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Indicators" detailTitle:@"Shows Horizontal Indicator" flag:self.showsHorizontalScrollIndicator] noneInsets];
    model2.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsHorizontalScrollIndicator = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Shows Vertical Indicator" flag:self.showsVerticalScrollIndicator];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsVerticalScrollIndicator = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Scrolling" detailTitle:@"Enable" flag:self.isScrollEnabled] noneInsets];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.scrollEnabled = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Paging" flag:self.isPagingEnabled] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.pagingEnabled = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Direction Lock" flag:self.isDirectionalLockEnabled];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.directionalLockEnabled = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Bounce" detailTitle:@"Bounces" flag:self.bounces] noneInsets];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.bounces = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Bounce Horizontal" flag:self.alwaysBounceHorizontal] noneInsets];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.alwaysBounceHorizontal = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Bounce Vertical" flag:self.alwaysBounceVertical];
    model9.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.alwaysBounceVertical = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model9];
    
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Zoom Min" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.minimumZoomScale)]] noneInsets];
    model10.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumZoomScale"];
    };
    [settings addObject:model10];
    
    ZooHierarchyCellModel *model11 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Max" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.maximumZoomScale)]];
    model11.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumZoomScale"];
    };
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Touch" detailTitle:[NSString stringWithFormat:@"Zoom Bounces %@",[self zoo_hierarchyBoolDescription:self.isZoomBouncing]]] noneInsets];
    [settings addObject:model12];
    
    ZooHierarchyCellModel *model13 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Delays Content Touches" flag:self.delaysContentTouches] noneInsets];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.delaysContentTouches = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    ZooHierarchyCellModel *model14 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Cancellable Content Touches" flag:self.canCancelContentTouches];
    model14.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.canCancelContentTouches = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model14];
    
    ZooHierarchyCellModel *model15 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[ZooEnumDescription scrollViewKeyboardDismissModeDescription:self.keyboardDismissMode]];
    model15.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription scrollViewKeyboardDismissModes] currentAction:[ZooEnumDescription scrollViewKeyboardDismissModeDescription:weakSelf.keyboardDismissMode] completion:^(NSInteger index) {
            weakSelf.keyboardDismissMode = index;
        }];
    };
    [settings addObject:model15];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Scroll View" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITableView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfSections]] noneInsets];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Style" detailTitle:[ZooEnumDescription tableViewStyleDescription:self.style]] noneInsets];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Separator" detailTitle:[ZooEnumDescription tableViewCellSeparatorStyleDescription:self.separatorStyle]] noneInsets];
    model3.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription tableViewCellSeparatorStyles] currentAction:[ZooEnumDescription tableViewCellSeparatorStyleDescription:weakSelf.separatorStyle] completion:^(NSInteger index) {
            weakSelf.separatorStyle = index;
        }];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchyColorDescription:self.separatorColor]];
    model4.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"separatorColor"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Data Source" detailTitle:[self zoo_hierarchyObjectDescription:self.dataSource]] noneInsets];
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Delegate" detailTitle:[self zoo_hierarchyObjectDescription:self.delegate]];
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Separator Inset" detailTitle:[self zoo_hierarchyInsetsTopBottomDescription:self.separatorInset]] noneInsets];
    model7.block = ^{
        [weakSelf zoo_showEdgeInsetsAndAutomicSetWithKeyPath:@"separatorInset"];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchyInsetsLeftRightDescription:self.separatorInset]] noneInsets];
    [settings addObject:model8];
    
    if (@available(iOS 11.0, *)) {
        ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[ZooEnumDescription tableViewSeparatorInsetReferenceDescription:self.separatorInsetReference]];
        model9.block = ^{
            [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription tableViewSeparatorInsetReferences] currentAction:[ZooEnumDescription tableViewSeparatorInsetReferenceDescription:weakSelf.separatorInsetReference] completion:^(NSInteger index) {
                weakSelf.separatorInsetReference = index;
            }];
        };
        [settings addObject:model9];
    }
    
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Selection" detailTitle:self.allowsSelection ? @"Allowed" : @"Disabled" flag:self.allowsSelection] noneInsets];
    model10.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsSelection = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model10];
    
    ZooHierarchyCellModel *model11 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@",self.allowsMultipleSelection ? @"" : @"Disabled"] flag:self.allowsMultipleSelection] noneInsets];
    model11.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsMultipleSelection = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Edit Selection" detailTitle:self.allowsSelectionDuringEditing ? @"Allowed" : @"Disabled" flag:self.allowsSelectionDuringEditing] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsSelectionDuringEditing = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    ZooHierarchyCellModel *model13 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@",self.allowsMultipleSelectionDuringEditing ? @"" : @"Disabled"] flag:self.allowsMultipleSelectionDuringEditing];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsMultipleSelectionDuringEditing = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    ZooHierarchyCellModel *model14 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Min Display" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.sectionIndexMinimumDisplayRowCount]] noneInsets];
    model14.block = ^{
        [weakSelf zoo_showIntAlertAndAutomicSetWithKeyPath:@"sectionIndexMinimumDisplayRowCount"];
    };
    [settings addObject:model14];
    
    ZooHierarchyCellModel *model15 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Text" detailTitle:[self zoo_hierarchyColorDescription:self.sectionIndexColor]] noneInsets];
    model15.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexColor"];
    };
    [settings addObject:model15];
    
    ZooHierarchyCellModel *model16 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Background" detailTitle:[self zoo_hierarchyColorDescription:self.sectionIndexBackgroundColor]] noneInsets];
    model16.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexBackgroundColor"];
    };
    [settings addObject:model16];
    
    ZooHierarchyCellModel *model17 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Tracking" detailTitle:[self zoo_hierarchyColorDescription:self.sectionIndexTrackingBackgroundColor]];
    model17.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexTrackingBackgroundColor"];
    };
    model17.block = ^{
        
    };
    [settings addObject:model17];
    
    ZooHierarchyCellModel *model18 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Row Height" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.rowHeight)]] noneInsets];
    model18.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"rowHeight"];
    };
    [settings addObject:model18];
    
    ZooHierarchyCellModel *model19 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Section Header" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.sectionHeaderHeight)]] noneInsets];
    model19.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"sectionHeaderHeight"];
    };
    [settings addObject:model19];
    
    ZooHierarchyCellModel *model20 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Section Footer" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.sectionFooterHeight)]];
    model20.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"sectionFooterHeight"];
    };
    [settings addObject:model20];

    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Table View" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITableViewCell (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Image" detailTitle:[self zoo_hierarchyImageDescription:self.imageView.image]];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Identifier" detailTitle:[self zoo_hierarchyTextDescription:self.reuseIdentifier]];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Selection" detailTitle:[ZooEnumDescription tableViewCellSelectionStyleDescription:self.selectionStyle]] noneInsets];
    model3.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription tableViewCellSelectionStyles] currentAction:[ZooEnumDescription tableViewCellSelectionStyleDescription:weakSelf.selectionStyle] completion:^(NSInteger index) {
            weakSelf.selectionStyle = index;
        }];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Accessory" detailTitle:[ZooEnumDescription tableViewCellAccessoryTypeDescription:self.accessoryType]] noneInsets];
    model4.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription tableViewCellAccessoryTypes] currentAction:[ZooEnumDescription tableViewCellAccessoryTypeDescription:weakSelf.accessoryType] completion:^(NSInteger index) {
            weakSelf.accessoryType = index;
        }];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Editing Acc." detailTitle:[ZooEnumDescription tableViewCellAccessoryTypeDescription:self.editingAccessoryType]];
    model5.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription tableViewCellAccessoryTypes] currentAction:[ZooEnumDescription tableViewCellAccessoryTypeDescription:weakSelf.editingAccessoryType] completion:^(NSInteger index) {
            weakSelf.editingAccessoryType = index;
        }];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Indentation" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.indentationLevel]] noneInsets];
    model6.block = ^{
        [weakSelf zoo_showIntAlertAndAutomicSetWithKeyPath:@"indentationLevel"];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.indentationWidth)]] noneInsets];
    model7.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"indentationWidth"];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Indent While Editing" flag:self.shouldIndentWhileEditing] noneInsets];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.shouldIndentWhileEditing = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Shows Re-order Controls" flag:self.showsReorderControl];
    model9.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsReorderControl = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model9];
    
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Separator Inset" detailTitle:[self zoo_hierarchyInsetsTopBottomDescription:self.separatorInset]] noneInsets];
    model10.block = ^{
        [weakSelf zoo_showEdgeInsetsAndAutomicSetWithKeyPath:@"separatorInset"];
    };
    [settings addObject:model10];
    
    ZooHierarchyCellModel *model11 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchyInsetsLeftRightDescription:self.separatorInset]];
    [settings addObject:model11];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Table View Cell" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UICollectionView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfSections]];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Delegate" detailTitle:[self zoo_hierarchyObjectDescription:self.delegate]] noneInsets];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Data Source" detailTitle:[self zoo_hierarchyObjectDescription:self.dataSource]] noneInsets];
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Layout" detailTitle:[self zoo_hierarchyObjectDescription:self.collectionViewLayout]];
    [settings addObject:model4];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Collection View" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UICollectionReusableView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Identifier" detailTitle:[self zoo_hierarchyTextDescription:self.reuseIdentifier]] noneInsets];
    [settings addObject:model1];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Collection Reusable View" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITextView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Plain Text" detailTitle:[self zoo_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Attributed Text" detailTitle:[self zoo_hierarchyObjectDescription:self.attributedText]] noneInsets];
    model2.block = ^{
        [weakSelf zoo_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedText"];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Allows Editing Attributes" flag:self.allowsEditingTextAttributes] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsEditingTextAttributes = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Color" detailTitle:[self zoo_hierarchyColorDescription:self.textColor]] noneInsets];
    model4.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Font" detailTitle:[self zoo_hierarchyObjectDescription:self.font]] noneInsets];
    model5.block = ^{
        [weakSelf zoo_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Alignment" detailTitle:[ZooEnumDescription textAlignmentDescription:self.textAlignment]];
    model6.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAlignments] currentAction:[ZooEnumDescription textAlignmentDescription:weakSelf.textAlignment] completion:^(NSInteger index) {
            weakSelf.textAlignment = index;
        }];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Editable" flag:self.isEditable] noneInsets];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.editable = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Selectable" flag:self.isSelectable];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.selectable = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Data Detectors" detailTitle:@"Phone Number" flag:self.dataDetectorTypes & UIDataDetectorTypePhoneNumber] noneInsets];
    model9.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypePhoneNumber;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypePhoneNumber;
        }
    };
    [settings addObject:model9];
    
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Link" flag:self.dataDetectorTypes & UIDataDetectorTypeLink] noneInsets];
    model10.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeLink;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeLink;
        }
    };
    [settings addObject:model10];
    
    ZooHierarchyCellModel *model11 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Address" flag:self.dataDetectorTypes & UIDataDetectorTypeAddress] noneInsets];
    model11.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeAddress;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeAddress;
        }
    };
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Calendar Event" flag:self.dataDetectorTypes & UIDataDetectorTypeCalendarEvent] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeCalendarEvent;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeCalendarEvent;
        }
    };
    [settings addObject:model12];
    
    if (@available(iOS 10.0, *)) {
        ZooHierarchyCellModel *model13 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Shipment Tracking Number" flag:self.dataDetectorTypes & UIDataDetectorTypeShipmentTrackingNumber] noneInsets];
        model13.changePropertyBlock = ^(id  _Nullable obj) {
            if ([obj boolValue]) {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeShipmentTrackingNumber;
            } else {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeShipmentTrackingNumber;
            }
        };
        [settings addObject:model13];
        
        ZooHierarchyCellModel *model14 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Flight Number" flag:self.dataDetectorTypes & UIDataDetectorTypeFlightNumber] noneInsets];
        model14.changePropertyBlock = ^(id  _Nullable obj) {
            if ([obj boolValue]) {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeFlightNumber;
            } else {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeFlightNumber;
            }
        };
        [settings addObject:model14];
        
        ZooHierarchyCellModel *model15 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Lookup Suggestion" flag:self.dataDetectorTypes & UIDataDetectorTypeLookupSuggestion];
        model15.changePropertyBlock = ^(id  _Nullable obj) {
            if ([obj boolValue]) {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeLookupSuggestion;
            } else {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeLookupSuggestion;
            }
        };
        [settings addObject:model15];
    } else {
        [model12 normalInsets];
    }
    
    ZooHierarchyCellModel *model16 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Capitalization" detailTitle:[ZooEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model16.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAutocapitalizationTypes] currentAction:[ZooEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType] completion:^(NSInteger index) {
            weakSelf.autocapitalizationType = index;
        }];
    };
    [settings addObject:model16];
    
    ZooHierarchyCellModel *model17 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Correction" detailTitle:[ZooEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model17.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAutocorrectionTypes] currentAction:[ZooEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType] completion:^(NSInteger index) {
            weakSelf.autocorrectionType = index;
        }];
    };
    [settings addObject:model17];
    
    ZooHierarchyCellModel *model18 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[ZooEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    model18.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription keyboardTypes] currentAction:[ZooEnumDescription keyboardTypeDescription:weakSelf.keyboardType] completion:^(NSInteger index) {
            weakSelf.keyboardType = index;
        }];
    };
    [settings addObject:model18];
    
    ZooHierarchyCellModel *model19 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Appearance" detailTitle:[ZooEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    model19.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription keyboardAppearances] currentAction:[ZooEnumDescription keyboardAppearanceDescription:weakSelf.keyboardAppearance] completion:^(NSInteger index) {
            weakSelf.keyboardAppearance = index;
        }];
    };
    [settings addObject:model19];
    
    ZooHierarchyCellModel *model20 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Return Key" detailTitle:[ZooEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    model20.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription returnKeyTypes] currentAction:[ZooEnumDescription returnKeyTypeDescription:weakSelf.returnKeyType] completion:^(NSInteger index) {
            weakSelf.returnKeyType = index;
        }];
    };
    [settings addObject:model20];
    
    ZooHierarchyCellModel *model21 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Auto-enable Return Key" flag:self.enablesReturnKeyAutomatically] noneInsets];
    model21.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enablesReturnKeyAutomatically = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model21];
    
    ZooHierarchyCellModel *model22 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Secure Entry" flag:self.isSecureTextEntry];
    model22.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.secureTextEntry = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model22];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Text View" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIDatePicker (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Mode" detailTitle:[ZooEnumDescription datePickerModeDescription:self.datePickerMode]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription datePickerModes] currentAction:[ZooEnumDescription datePickerModeDescription:weakSelf.datePickerMode] completion:^(NSInteger index) {
            weakSelf.datePickerMode = index;
        }];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Locale Identifier" detailTitle:self.locale.localeIdentifier] noneInsets];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Interval" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.minuteInterval]];
    model3.block = ^{
        [weakSelf zoo_showIntAlertAndAutomicSetWithKeyPath:@"minuteInterval"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Date" detailTitle:[self zoo_hierarchyDateDescription:self.date]] noneInsets];
    model4.block = ^{
        [weakSelf zoo_showDateAlertAndAutomicSetWithKeyPath:@"date"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Min Date" detailTitle:[self zoo_hierarchyDateDescription:self.minimumDate]] noneInsets];
    model5.block = ^{
        [weakSelf zoo_showDateAlertAndAutomicSetWithKeyPath:@"minimumDate"];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Max Date" detailTitle:[self zoo_hierarchyDateDescription:self.maximumDate]];
    model6.block = ^{
        [weakSelf zoo_showDateAlertAndAutomicSetWithKeyPath:@"maximumDate"];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Count Down" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.countDownDuration)]];
    [settings addObject:model7];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Date Picker" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIPickerView (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Delegate" detailTitle:[self zoo_hierarchyObjectDescription:self.delegate]];
    [settings addObject:model1];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Picker View" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UINavigationBar (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Style" detailTitle:[ZooEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription barStyles] currentAction:[ZooEnumDescription barStyleDescription:weakSelf.barStyle] completion:^(NSInteger index) {
            weakSelf.barStyle = index;
        }];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Translucent" flag:self.isTranslucent] noneInsets];
    model2.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model2];
    
    if (@available(iOS 11.0, *)) {
        ZooHierarchyCellModel *model3 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Prefers Large Titles" flag:self.prefersLargeTitles] noneInsets];
        model3.changePropertyBlock = ^(id  _Nullable obj) {
            weakSelf.prefersLargeTitles = [obj boolValue];
            [weakSelf zoo_postHierarchyChangeNotification];
        };
        [settings addObject:model3];
    }
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self zoo_hierarchyColorDescription:self.barTintColor]] noneInsets];
    model4.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow Image" detailTitle:[self zoo_hierarchyImageDescription:self.shadowImage]] noneInsets];
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Back Image" detailTitle:[self zoo_hierarchyImageDescription:self.backIndicatorImage]] noneInsets];
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Back Mask" detailTitle:[self zoo_hierarchyImageDescription:self.backIndicatorTransitionMaskImage]];
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Title Attr." detailTitle:nil] noneInsets];
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Title Font" detailTitle:[self zoo_hierarchyObjectDescription:self.titleTextAttributes[NSFontAttributeName]]] noneInsets];
    if (self.titleTextAttributes[NSFontAttributeName]) {
        model9.block = ^{
            __block UIFont *font = weakSelf.titleTextAttributes[NSFontAttributeName];
            if (!font) {
                return;
            }
            [weakSelf zoo_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@",[ZooHierarchyFormatterTool formatNumber:@(font.pointSize)]] handler:^(NSString * _Nullable newText) {
                NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:weakSelf.titleTextAttributes];
                attributes[NSFontAttributeName] = [font fontWithSize:[newText doubleValue]];
                weakSelf.titleTextAttributes = [attributes copy];
            }];
        };
    }
    [settings addObject:model9];
    
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Title Color" detailTitle:[self zoo_hierarchyColorDescription:self.titleTextAttributes[NSForegroundColorAttributeName]]] noneInsets];
    [settings addObject:model10];
    
    NSShadow *shadow = self.titleTextAttributes[NSShadowAttributeName];
    if (![shadow isKindOfClass:[NSShadow class]]) {
        shadow = nil;
    }
    
    ZooHierarchyCellModel *model11 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self zoo_hierarchyColorDescription:shadow.shadowColor]] noneInsets];
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self zoo_hierarchySizeDescription:shadow.shadowOffset]];
    [settings addObject:model12];
    
    if (@available(iOS 11.0, *)) {
        ZooHierarchyCellModel *model13 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Large Title Attr." detailTitle:nil] noneInsets];
        [settings addObject:model13];
        
        ZooHierarchyCellModel *model14 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Title Font" detailTitle:[self zoo_hierarchyColorDescription:self.largeTitleTextAttributes[NSFontAttributeName]]] noneInsets];
        if (self.largeTitleTextAttributes[NSFontAttributeName]) {
            model14.block = ^{
                __block UIFont *font = weakSelf.largeTitleTextAttributes[NSFontAttributeName];
                if (!font) {
                    return;
                }
                [weakSelf zoo_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@",[ZooHierarchyFormatterTool formatNumber:@(font.pointSize)]] handler:^(NSString * _Nullable newText) {
                    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:weakSelf.largeTitleTextAttributes];
                    attributes[NSFontAttributeName] = [font fontWithSize:[newText doubleValue]];
                    weakSelf.largeTitleTextAttributes = [attributes copy];
                }];
            };
        }
        [settings addObject:model14];
        
        ZooHierarchyCellModel *model15 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Title Color" detailTitle:[self zoo_hierarchyColorDescription:self.largeTitleTextAttributes[NSForegroundColorAttributeName]]] noneInsets];
        [settings addObject:model15];
        
        shadow = self.largeTitleTextAttributes[NSShadowAttributeName];
        if (![shadow isKindOfClass:[NSShadow class]]) {
            shadow = nil;
        }
        
        ZooHierarchyCellModel *model16 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self zoo_hierarchyColorDescription:shadow.shadowColor]] noneInsets];
        [settings addObject:model16];
        
        ZooHierarchyCellModel *model17 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self zoo_hierarchySizeDescription:shadow.shadowOffset]];
        [settings addObject:model17];
    }
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Navigation Bar" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIToolbar (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Style" detailTitle:[ZooEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription barStyles] currentAction:[ZooEnumDescription barStyleDescription:weakSelf.barStyle] completion:^(NSInteger index) {
            weakSelf.barStyle = index;
        }];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Translucent" flag:self.isTranslucent] noneInsets];
    model2.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self zoo_hierarchyColorDescription:self.barTintColor]];
    model3.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Tool Bar" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITabBar (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Background" detailTitle:[self zoo_hierarchyImageDescription:self.backgroundImage]] noneInsets];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self zoo_hierarchyImageDescription:self.shadowImage]] noneInsets];
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Selection" detailTitle:[self zoo_hierarchyImageDescription:self.selectionIndicatorImage]];
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Style" detailTitle:[ZooEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model4.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription barStyles] currentAction:[ZooEnumDescription barStyleDescription:weakSelf.barStyle] completion:^(NSInteger index) {
            weakSelf.barStyle = index;
        }];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Translucent" flag:self.isTranslucent] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self zoo_hierarchyColorDescription:self.barTintColor]];
    model6.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Style" detailTitle:[ZooEnumDescription tabBarItemPositioningDescription:self.itemPositioning]] noneInsets];
    model7.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription tabBarItemPositionings] currentAction:[ZooEnumDescription tabBarItemPositioningDescription:weakSelf.itemPositioning] completion:^(NSInteger index) {
            weakSelf.itemPositioning = index;
        }];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Item Width" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.itemWidth)]] noneInsets];
    model8.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"itemWidth"];
    };
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Item Spacing" detailTitle:[ZooHierarchyFormatterTool formatNumber:@(self.itemSpacing)]];
    model9.block = ^{
        [weakSelf zoo_showDoubleAlertAndAutomicSetWithKeyPath:@"itemSpacing"];
    };
    [settings addObject:model9];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Tab Bar" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UISearchBar (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Text" detailTitle:[self zoo_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf zoo_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Placeholder" detailTitle:[self zoo_hierarchyTextDescription:self.placeholder]] noneInsets];
    model2.block = ^{
        [weakSelf zoo_showTextAlertAndAutomicSetWithKeyPath:@"placeholder"];
    };
    [settings addObject:model2];
    
    ZooHierarchyCellModel *model3 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Prompt" detailTitle:[self zoo_hierarchyTextDescription:self.prompt]];
    model3.block = ^{
        [weakSelf zoo_showTextAlertAndAutomicSetWithKeyPath:@"prompt"];
    };
    [settings addObject:model3];
    
    ZooHierarchyCellModel *model4 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Search Style" detailTitle:[ZooEnumDescription searchBarStyleDescription:self.searchBarStyle]] noneInsets];
    model4.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription searchBarStyles] currentAction:[ZooEnumDescription searchBarStyleDescription:weakSelf.searchBarStyle] completion:^(NSInteger index) {
            weakSelf.searchBarStyle = index;
        }];
    };
    [settings addObject:model4];
    
    ZooHierarchyCellModel *model5 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Bar Style" detailTitle:[ZooEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model5.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription barStyles] currentAction:[ZooEnumDescription barStyleDescription:weakSelf.barStyle] completion:^(NSInteger index) {
            weakSelf.barStyle = index;
        }];
    };
    [settings addObject:model5];
    
    ZooHierarchyCellModel *model6 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Translucent" flag:self.isTranslucent] noneInsets];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    ZooHierarchyCellModel *model7 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[self zoo_hierarchyColorDescription:self.barTintColor]];
    model7.block = ^{
        [weakSelf zoo_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model7];
    
    ZooHierarchyCellModel *model8 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Background" detailTitle:[self zoo_hierarchyImageDescription:self.backgroundImage]] noneInsets];
    [settings addObject:model8];
    
    ZooHierarchyCellModel *model9 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Scope Bar" detailTitle:[self zoo_hierarchyImageDescription:self.scopeBarBackgroundImage]];
    [settings addObject:model9];
    
    ZooHierarchyCellModel *model10 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Text Offset" detailTitle:[self zoo_hierarchyOffsetDescription:self.searchTextPositionAdjustment]] noneInsets];
    [settings addObject:model10];
    
    ZooHierarchyCellModel *model11 = [[ZooHierarchyCellModel alloc] initWithTitle:@"BG Offset" detailTitle:[self zoo_hierarchyOffsetDescription:self.searchFieldBackgroundPositionAdjustment]];
    [settings addObject:model11];
    
    ZooHierarchyCellModel *model12 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Options" detailTitle:@"Shows Search Results Button" flag:self.showsSearchResultsButton] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsSearchResultsButton = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    ZooHierarchyCellModel *model13 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Shows Bookmarks Button" flag:self.showsBookmarkButton] noneInsets];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsBookmarkButton = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    ZooHierarchyCellModel *model14 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Shows Cancel Button" flag:self.showsCancelButton] noneInsets];
    model14.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsCancelButton = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model14];
    
    ZooHierarchyCellModel *model15 = [[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:@"Shows Scope Bar" flag:self.showsScopeBar];
    model15.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsScopeBar = [obj boolValue];
        [weakSelf zoo_postHierarchyChangeNotification];
    };
    [settings addObject:model15];
    
    ZooHierarchyCellModel *model16 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Scope Titles" detailTitle:[self zoo_hierarchyObjectDescription:self.scopeButtonTitles]];
    [settings addObject:model16];
    
    ZooHierarchyCellModel *model17 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Capitalization" detailTitle:[ZooEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model17.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAutocapitalizationTypes] currentAction:[ZooEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType] completion:^(NSInteger index) {
            weakSelf.autocapitalizationType = index;
        }];
    };
    [settings addObject:model17];
    
    ZooHierarchyCellModel *model18 = [[[ZooHierarchyCellModel alloc] initWithTitle:@"Correction" detailTitle:[ZooEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model18.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription textAutocorrectionTypes] currentAction:[ZooEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType] completion:^(NSInteger index) {
            weakSelf.autocorrectionType = index;
        }];
    };
    [settings addObject:model18];
    
    ZooHierarchyCellModel *model19 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[ZooEnumDescription keyboardTypeDescription:self.keyboardType]];
    model19.block = ^{
        [weakSelf zoo_showActionSheetWithActions:[ZooEnumDescription keyboardTypes] currentAction:[ZooEnumDescription keyboardTypeDescription:weakSelf.keyboardType] completion:^(NSInteger index) {
            weakSelf.keyboardType = index;
        }];
    };
    [settings addObject:model19];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Search Bar" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIWindow (ZooHierarchy)

- (NSArray<ZooHierarchyCategoryModel *> *)zoo_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    ZooHierarchyCellModel *model1 = [[[ZooHierarchyCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Key Window %@",[self zoo_hierarchyBoolDescription:self.isKeyWindow]]] noneInsets];
    [settings addObject:model1];
    
    ZooHierarchyCellModel *model2 = [[ZooHierarchyCellModel alloc] initWithTitle:@"Root Controller" detailTitle:[self zoo_hierarchyObjectDescription:self.rootViewController]];
    [settings addObject:model2];
    
    ZooHierarchyCategoryModel *model = [[ZooHierarchyCategoryModel alloc] initWithTitle:@"Window" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super zoo_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end
