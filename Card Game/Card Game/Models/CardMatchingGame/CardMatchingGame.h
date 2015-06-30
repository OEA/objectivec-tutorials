//
//  CardMatchingGame.h
//  Card Game
//
//  Created by Ömer Emre Aslan on 30/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject
//Current game score
@property (nonatomic)NSUInteger score;
//Cards on the deck
@property (strong, nonatomic)NSMutableArray *cards;
//Current deck on the game
-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
@end
