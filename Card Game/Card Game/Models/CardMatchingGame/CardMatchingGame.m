//
//  CardMatchingGame.m
//  Card Game
//
//  Created by Ömer Emre Aslan on 30/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "CardMatchingGame.h"


@interface CardMatchingGame()
@property (nonatomic, readwrite)NSUInteger score;
@end


@implementation CardMatchingGame

-(NSMutableArray *)cards
{
    if (!_cards)
        _cards = [NSMutableArray new];
    
    return _cards;
}

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    for (int i=0; i<count; i++) {
        Card *card = [deck drawRandomCard];
        [self.cards addObject:card];
    }
    return self;
}

@end
