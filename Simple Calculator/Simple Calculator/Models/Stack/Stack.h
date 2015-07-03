//
//  Stack.h
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 02/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject <NSCopying>

@property (strong, nonatomic) NSMutableArray *stack;

- (void)push:(id)object;
- (id)pop;
- (id)bottom;
- (NSUInteger)count;
- (void)pushTop:(id)object;
- (void)removeLastItem;
- (id)top;
-(NSMutableArray *)cloneArray: (NSMutableArray *) myArray;
@end
