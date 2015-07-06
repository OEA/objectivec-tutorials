//
//  CalculatorManager.h
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 01/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Calculator.h"
#import "Stack.h"

@interface CalculatorManager : NSObject

+(instancetype)sharedInstance;
@property (nonatomic) BOOL isOnProgress;
@property (nonatomic) CalculationMode cMode;
@property (strong, nonatomic, readonly) Stack *transactionStack;

- (NSNumber *)processNumbers:(CalculationMode)cMode;

- (BOOL)isFloat:(NSNumber *)number;
- (NSNumber *)calculateFromInfixExpression:(Stack *)infixStack;
- (void)addItemToTransaction:(id)object;
- (void)removeLastItemInTransaction;
@end
