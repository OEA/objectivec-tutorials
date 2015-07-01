//
//  Calculator.m
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 01/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "Calculator.h"


@interface Calculator()

@end

@implementation Calculator

+ (NSNumber *)processNumbers:(CalculationMode)cMode 
                 firstNumber:(NSNumber *)first 
                secondNumber:(NSNumber *)second
{
    NSNumber *result = nil;
    switch (cMode) {
        case CalculationModeAdd:
            result = [NSNumber numberWithFloat:[first floatValue] + [second floatValue]];
            break;
        case CalculationModeSubstract:
            result = [NSNumber numberWithFloat:[first floatValue] - [second floatValue]];
            break;
        case CalculationModeMultiply:
            result = [NSNumber numberWithFloat:[first floatValue] * [second floatValue]];
            break;
        case CalculationModeDivide:
            result = [NSNumber numberWithFloat:[first floatValue] / [second floatValue]];
            break;
        default:
            break;
    }
    return result;
}

@end
