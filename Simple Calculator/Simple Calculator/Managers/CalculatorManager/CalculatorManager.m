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

- (id)init 
{
    self = [super init];
    if (self) {
        _stack = [Stack new];
    }
    return self;
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

- (NSNumber *)calculateFromInfixExpression:(Stack *)infixStack
{
    // This is an example of a functional test case.
    Stack *operand = [Stack new];
    Stack *operator = [Stack new];
    
    while ([infixStack count]) {
        if ([[infixStack bottom] isKindOfClass:[NSString class]]) {
            NSString *obj = [infixStack pop];
            if ([obj isEqualToString:@"*"] || [obj isEqualToString:@"/"]) {
                [operand push:[infixStack pop]];
                [operand push:obj];
            } else {
                [operator push:obj];
                if ([operator count] == 2) {
                    [operand push:[operator pop]];
                }
            }
        } else {
            [operand push:[infixStack pop]];
        }
        
    }
    while ([operator count]) {
        NSString *obj = [operator pop];
        [operand push:obj];
    }
    
    
    NSNumber *result = @(0);
    
    while ([operand count] != 1) {
        id fobj = [operand pop];
        id sobj = [operand pop];
        id tobj = [operand bottom];
        
        if ([tobj isKindOfClass:[NSString class]]) {
            
            NSNumber *firstNumber = fobj;
            NSNumber *secondNumber = sobj;
            id obj = [operand pop];
            NSString *operatorStr = obj;
            @try {
                if ([operatorStr isEqualToString:@"+"])
                    result = [NSNumber numberWithFloat:([firstNumber floatValue] + [secondNumber floatValue])];
                if ([operatorStr isEqualToString:@"-"])
                    result = [NSNumber numberWithFloat:([firstNumber floatValue] - [secondNumber floatValue])];
                if ([operatorStr isEqualToString:@"*"])
                    result = [NSNumber numberWithFloat:([firstNumber floatValue] * [secondNumber floatValue])];
                if ([operatorStr isEqualToString:@"/"])
                    result = [NSNumber numberWithFloat:([firstNumber floatValue] / [secondNumber floatValue])];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
            @finally {
                
            }
            
            [operand pushTop:result];
            
        } else {
            
            NSNumber *secondNumber = sobj;
            NSNumber *thirdNumber = [operand pop];
            NSString *operatorStr = [operand pop];
            
            @try {
                if ([operatorStr isEqualToString:@"+"])
                    result = [NSNumber numberWithFloat:([secondNumber floatValue] + [thirdNumber floatValue])];
                if ([operatorStr isEqualToString:@"-"])
                    result = [NSNumber numberWithFloat:([secondNumber floatValue] - [thirdNumber floatValue])];
                if ([operatorStr isEqualToString:@"*"])
                    result = [NSNumber numberWithFloat:([secondNumber floatValue] * [thirdNumber floatValue])];
                if ([operatorStr isEqualToString:@"/"])
                    result = [NSNumber numberWithFloat:([secondNumber floatValue] / [thirdNumber floatValue])];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
            @finally {
                
            }
            
            [operand pushTop:result];
            [operand pushTop:fobj];
            
        }
        
        
        
        
    }
    
    return result;   
}
- (NSNumber *)processNumbers:(CalculationMode)cMode
{
    
    
    
    
    
    
    
    return [Calculator processNumbers:cMode firstNumber:self.firstNumber secondNumber:self.secondNumber];
}

- (NSNumber *)convertStringToNumber:(NSString *)number
{
    NSNumberFormatter *f = [NSNumberFormatter new];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:number];
    return myNumber;
}


- (void)addOperand:(NSObject *)object
{
    [_stack push:object];
}

- (void)addOperator:(NSObject *)object
{
    [_stack push:object];
}


@end
