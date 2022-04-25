//
//  ZooHierarchyFormatterTool.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.
#import <UIKit/UIKit.h>
#import "ZooHierarchyFormatterTool.h"

static ZooHierarchyFormatterTool *_instance = nil;

@interface ZooHierarchyFormatterTool ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation ZooHierarchyFormatterTool

#pragma mark - Public
+ (NSString *)stringFromDate:(NSDate *)date {
    return [[self shared] stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    return [[self shared] dateFromString:string];
}

+ (NSString *)formatNumber:(NSNumber *)number {
    return [[self shared] formatNumber:number];
}

+ (NSString *)stringFromFrame:(CGRect)frame {
    return [NSString stringWithFormat:@"{{%@, %@}, {%@, %@}}",[self formatNumber:@(frame.origin.x)],[self formatNumber:@(frame.origin.y)],[self formatNumber:@(frame.size.width)],[self formatNumber:@(frame.size.height)]];
}

#pragma mark - Primary
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZooHierarchyFormatterTool alloc] init];
    });
    return _instance;
}

- (NSString *)stringFromDate:(NSDate *)date {
    if (!date) {
        return nil;
    }
    return [self.formatter stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string {
    if (!string) {
        return nil;
    }
    return [self.formatter dateFromString:string];
}

- (NSString *)formatNumber:(NSNumber *)number {
    return [self.numberFormatter stringFromNumber:number];
}

#pragma mark - Getters and setters
- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _formatter;
}

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _numberFormatter.maximumFractionDigits = 2;
        _numberFormatter.usesGroupingSeparator = NO;
    }
    return _numberFormatter;
}

@end
