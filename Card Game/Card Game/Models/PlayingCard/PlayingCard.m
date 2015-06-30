//
//  PlayingCard.m
//  Card Game
//
//  Created by Ömer Emre Aslan on 29/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

+ (NSArray * )validSuits {
    return @[@"s", @"c", @"h", @"d"];
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [self.suit stringByAppendingString:rankStrings[self.rank]];
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

-(int)match:(PlayingCard *)otherCard
{
    NSLog(@"First card suit: %@ , rank: %li, Second card suit: %@, rank: %li",self.suit, self.rank, otherCard.suit, otherCard.rank);
    int score = 0;
    if (otherCard.rank == self.rank) {
        self.matched = YES;
        otherCard.matched = YES;
        score = 1;
    } else if ([[otherCard suit] isEqualToString:self.suit]) {
        self.matched = YES;
        otherCard.matched = YES;
        score = 4;
    } else {
        score = -1;
    }
    return score;
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"j", @"q", @"k"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
