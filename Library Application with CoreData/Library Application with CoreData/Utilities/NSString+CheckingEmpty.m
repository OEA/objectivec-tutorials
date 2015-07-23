//
//  NSString+CheckingEmpty.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 23/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "NSString+CheckingEmpty.h"

@implementation NSString (CheckingEmpty)

#pragma mark - isEmpty Method checks if it is empty or not not complete checking (w/out space)


- (BOOL)isEmpty
{
    return [self isEqualToString:@""];
}

- (BOOL)isCompleteEmpty
{
    if([[self stringByStrippingWhitespace] isEqualToString:@""])
        return YES;
    return NO;
}

- (NSString *)stringByStrippingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
