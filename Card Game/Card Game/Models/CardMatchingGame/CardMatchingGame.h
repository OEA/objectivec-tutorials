//
//  CardMatchingGame.h
//  Card Game
//
//  Created by Ömer Emre Aslan on 30/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly)NSUInteger score;
@property (strong, nonatomic)NSMutableArray *cards;
-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
@end
