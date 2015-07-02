//
//  CalculatorManager.h
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 01/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Calculator.h"

@interface CalculatorManager : NSObject

+(instancetype)sharedInstance;

@property (strong, nonatomic) NSNumber *firstNumber;

@property (strong, nonatomic) NSNumber *secondNumber;
@property (nonatomic) BOOL isOnProgress;
@property (nonatomic) CalculationMode cMode;

- (NSNumber *)processNumbers:(CalculationMode)cMode;

- (BOOL)isFloat:(NSNumber *)number;
- (NSString *)getPercentageOfNumber:(NSNumber *)number;
@end
