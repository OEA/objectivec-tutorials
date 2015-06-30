//
//  Deck.h
//  Card Game
//
//  Created by Ömer Emre Aslan on 29/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
@interface Deck : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *cards;

//Add card operations
-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(void)addCard:(Card *)card;

-(Card *)drawRandomCard;

//-(NSMutableArray *)cards;


@end
