//
//  Simple_CalculatorTests.m
//  Simple CalculatorTests
//
//  Created by Ömer Emre Aslan on 01/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Stack.h"
#import "CalculatorManager.h"

@interface Simple_CalculatorTests : XCTestCase

@end

@implementation Simple_CalculatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCalculation {
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(14)];
    [test push:@"-"];
    [test push:@(4)];
    [test push:@"*"];
    [test push:@(5)];
    [test push:@"*"];
    [test push:@(2)];
    [test push:@"+"];
    [test push:@(6)];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    int resultTest = [result intValue];
                  XCTAssertEqual(-20, resultTest);
    
}
- (void)testCalculation2 {
    
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(3)];
    [test push:@"*"];
    [test push:@(4)];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    int resultTest = [result intValue];
    XCTAssertEqual(12, resultTest);
}

- (void)testCalculation3 {
    
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(3)];
    [test push:@"*"];
    [test push:@(4)];
    [test push:@"*"];
    [test push:@(4)];
    [test push:@"*"];
    [test push:@(4)];
    [test push:@"*"];
    [test push:@(4)];
    [test push:@"/"];
    [test push:@(2)];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    int resultTest = [result intValue];
    XCTAssertEqual(384, resultTest);
}
- (void)testCalculation4 {
    
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(3)];
    [test push:@"*"];
    [test push:@(-4)];
    [test push:@"*"];
    [test push:@(4)];
    [test push:@"+"];
    [test push:@(8)];
    [test push:@"-"];
    [test push:@(2)];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    int resultTest = [result intValue];
    XCTAssertEqual(-42, resultTest);
}
- (void)testCalculation5 {
    
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(3)];
    [test push:@"/"];
    [test push:@(4)];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    float resultTest = [result floatValue];
    XCTAssertEqual(0.75, resultTest);
}
- (void)testCalculation6 {
    
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(3)];
    [test push:@"+"];
    [test push:@(14)];
    [test push:@"-"];
    [test push:@(4)];
    [test push:@"*"];
    [test push:@(3)];
    [test push:@"+"];
    [test push:@(7)];
    [test push:@"+"];
    [test push:@(2)];
    [test push:@"/"];
    [test push:@(4)];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    float resultTest = [result floatValue];
    XCTAssertEqual(12.5, resultTest);
}

- (void)testCalculation7 {
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(3)];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    int resultTest = [result intValue];
    XCTAssertEqual(3, resultTest);
}


- (void)testCalculation8 {
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(7)];
    [test push:@"*"];
    [test push:@(76)];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    int resultTest = [result intValue];
    XCTAssertEqual(532, resultTest);
}
- (void)testCalculation9 {
    CalculatorManager *cManager = [CalculatorManager new];
    Stack *test = [Stack new];
    [test push:@(2)];
    [test push:@"*"];
    [test push:@(2)];
    [test push:@"*"];
    NSNumber *result = [cManager calculateFromInfixExpression:test];
    [test push:@(2)];
    [test push:@"*"];
    [test push:@(2)];
    result = [cManager calculateFromInfixExpression:test];
    int resultTest = [result intValue];
    XCTAssertEqual(16, resultTest);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
