//
//  CALayer+BorderColor.m
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 06/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "CALayer+BorderColor.h"

@implementation CALayer (BorderColor)
- (void)setBorderColorWithWidth:(float)width :(UIColor *)color
{
    [self setBorderWidth:width];
    [self setBorderColor:color.CGColor];
}
@end
