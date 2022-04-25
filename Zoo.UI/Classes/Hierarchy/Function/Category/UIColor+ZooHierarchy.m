//
//  UIColor+ZooHierarchy.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "UIColor+ZooHierarchy.h"
#import "UIColor+Zoo.h"

@implementation UIColor (ZooHierarchy)

- (NSString *)zoo_HexString {
    int r = [self red] * 255.0;
    int g = [self green] * 255.0;
    int b = [self blue] * 255.0;
    return [NSString stringWithFormat:@"#%02X%02X%02X",r, g, b];
}

- (NSString *)zoo_description {
    if ([self isEqual:[UIColor clearColor]]) {
        return @"Clear Color";
    }
    
    NSString *color = [self zoo_systemColorName];
    
    if (color) {
        color = [color stringByAppendingFormat:@" (%@)",[self zoo_RGBADescrption]];
    } else {
        color = [self zoo_RGBADescrption];
    }
    
    return color;
}

- (NSString *)zoo_systemColorName {
    return [self valueForKeyPath:@"systemColorName"];
}

#pragma mark - Primary
- (NSString *)zoo_RGBADescrption {
    int r = [self red] * 255.0;
    int g = [self green] * 255.0;
    int b = [self blue] * 255.0;
    int a = [self alpha] * 255.0;
    NSString *desc = [NSString stringWithFormat:@"#%02X%02X%02X",r,g,b];
    if (a < 255) {
        desc = [desc stringByAppendingFormat:@", Alpha: %0.2f", [self alpha]];
    }
    return desc;
}

@end
