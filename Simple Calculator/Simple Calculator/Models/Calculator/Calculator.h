//
//  Calculator.h
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 01/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CalculationModeDivide,
    CalculationModeMultiply,
    CalculationModeSubstract,
    CalculationModeAdd,
    
}CalculationMode;

@interface Calculator : NSObject
+ (NSNumber *)processNumbers:(CalculationMode)cMode 
                 firstNumber:(NSNumber *)first 
                secondNumber:(NSNumber *)second;
@end
