//
//  Card.h
//  Card Game
//
//  Created by Ömer Emre Aslan on 29/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;
-(int)match:(NSArray *) otherCards;
@end