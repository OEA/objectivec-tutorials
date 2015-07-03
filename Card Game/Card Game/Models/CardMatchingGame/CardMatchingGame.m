//
//  CardMatchingGame.m
//  Card Game
//
//  Created by Ömer Emre Aslan on 30/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "CardMatchingGame.h"


@interface CardMatchingGame()

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
    if (self)
    {
        for (int i=0; i<count; i++) {
            id card = [deck drawRandomCard];
            PlayingCard *playingCard = (PlayingCard *)card;
            [self.cards addObject:playingCard];
        }
    }
    return self;
}



@end
