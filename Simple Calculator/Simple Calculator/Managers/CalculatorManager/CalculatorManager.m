//
//  CalculatorManager.m
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 01/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "CalculatorManager.h"
#import "Calculator.h"

@implementation CalculatorManager

- (BOOL)isFloat:(NSNumber *)number
{
    int intValueOfNumber = [number intValue];
    float floatValueOfNumber = [number floatValue];
    
    if (intValueOfNumber - floatValueOfNumber == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)getPercentageOfNumber:(NSNumber *)number
{
    float floatValue = [number floatValue];
    floatValue = floatValue / 100;
NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", floatValue];    
    return formattedNumber;
}

+ (instancetype)sharedInstance
{
    static CalculatorManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [self.class sharedInstance];
}

- (NSNumber *)processNumbers:(CalculationMode)cMode
{
    return [Calculator processNumbers:cMode firstNumber:self.firstNumber secondNumber:self.secondNumber];
}


@end
