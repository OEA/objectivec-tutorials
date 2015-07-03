//
//  Stack.m
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 02/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (NSMutableArray *)stack
{
    if (!_stack) {
        _stack = [NSMutableArray new];
    }
    return _stack;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_stack) {
            _stack = [NSMutableArray new];
        }
    }
    return self;
}

- (NSUInteger)count
{
    return [_stack count];
}

- (void)push:(id)object
{
    [_stack addObject:object];
}

- (id)pop
{
    id object = nil;
    if ([_stack count] > 0) {
        object = [_stack firstObject];
        [_stack removeObjectAtIndex:0];
    }
    return object;
}

- (id)bottom
{
    id object = nil;
    if ([_stack count] > 0) {
        object = [_stack firstObject];
    }
    return object;
}

- (void)pushTop:(id)object
{
    [_stack insertObject:object atIndex:0];
}





@end