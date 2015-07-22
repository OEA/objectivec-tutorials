//
//  NSDate+DateFromString.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 22/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "NSDate+DateFromString.h"

@implementation NSDate (DateFromString)

+ (NSDate *)dateFromString:(NSString *)dateStr
{
    if (!dateStr) {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        return [dateFormatter dateFromString:dateString];
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"yyyy"];
        return [dateFormat dateFromString:dateStr];
    }
}

@end
