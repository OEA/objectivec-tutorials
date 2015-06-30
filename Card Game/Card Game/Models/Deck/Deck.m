//
//  Deck.m
//  Card Game
//
//  Created by Ömer Emre Aslan on 29/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (strong, nonatomic, readwrite) NSMutableArray *cards;

@end

@implementation Deck

-(NSMutableArray *)cards
{
    if (!_cards)
        _cards = [NSMutableArray new];
    return _cards;
}

#pragma mark - Add Card Operations
-(void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

-(void)addCard:(Card *)card
{
    [self addCard:card atTop:@NO];
} 

#pragma mark - Draw Random Card
-(Card *)drawRandomCard
{
    Card *card = nil;
    if ([self.cards count]) {
        unsigned index = arc4random() % self.cards.count;
        card = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return card;
}

-(Card *)getCardAtIndex:(int)index
{
    Card *card = nil;
    if (index < [self.cards count]) {
        card = self.cards[index];
    }
    return card;
}

@end
