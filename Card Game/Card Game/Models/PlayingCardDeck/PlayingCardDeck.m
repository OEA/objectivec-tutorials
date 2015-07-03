//
//  PlayingCardDeck.m
//  Card Game
//
//  Created by Ömer Emre Aslan on 29/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

+(instancetype)sharedInstance
{
    static PlayingCardDeck *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        
        for (NSString *suit in [PlayingCard validSuits])
        {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [PlayingCard new];
                card.rank = rank;
                card.suit = suit;
                [instance addCard:card];
            }
        }
    });
    return instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

-(id)copy
{
    return [self.class sharedInstance];
}


@end
