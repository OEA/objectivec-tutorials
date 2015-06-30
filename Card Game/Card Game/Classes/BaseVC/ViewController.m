//
//  ViewController.m
//  Card Game
//
//  Created by Ömer Emre Aslan on 29/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) CardMatchingGame* game;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[PlayingCardDeck new]];
    
    [[self mainView] setBackgroundColor: [[UIColor alloc] initWithPatternImage: [UIImage imageNamed: @"card-table"]]];
    
    [self refreshUI];
    
    PlayingCardDeck *sharedInstance = [PlayingCardDeck new];
    PlayingCardDeck *cardDeck1 = [[PlayingCardDeck alloc] init];
    PlayingCardDeck *cardDeck2 = [sharedInstance copy];
    NSLog(@"sharedInstance: %@ c1: %@ c2: %@",sharedInstance,cardDeck1,cardDeck2);
}

- (void)refreshUI
{
    if ([self hasTwoCardChosen]) {
        [self clearTable];
    } else {
        [self refreshTable];
    }
    
}

-(void)clearTable
{
    for (UIButton *button in self.cardButtons){
        int index = (int)[self.cardButtons indexOfObject:button];
        if (index % 2 == 0) {
            [button setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
        }
        Card *card = [[self.game cards] objectAtIndex:index];
        card.chosen = NO;
    } 
}

-(void)refreshTable
{
    for (UIButton *button in self.cardButtons){
        int index = (int)[self.cardButtons indexOfObject:button];
        Card *card = [[self.game cards] objectAtIndex:index];
        if (!card.isChosen) {
            if (index % 2 == 0) {
                [button setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
            } else {
                [button setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            }
        }
    }
}




- (BOOL)hasTwoCardChosen
{
    int chosenCount = 0;
    for (UIButton *button in self.cardButtons){
        int index = (int)[self.cardButtons indexOfObject:button];
        Card *card = [[self.game cards] objectAtIndex:index];
        if (card.isChosen) {
            chosenCount++;
        }
    }
    return (chosenCount==2) ? YES : NO;
}

- (IBAction)cardButtonTapped:(id)sender
{
    
    [self refreshUI];
    int cardIndex =(int)[self.cardButtons indexOfObject:sender];
    [self drawRandomCard:cardIndex];
}

- (void)drawRandomCard:(int)cardButtonIndex
{
    UIButton *cardButton = self.cardButtons[cardButtonIndex];
    Card *card = [[self.game cards] objectAtIndex:cardButtonIndex];
    
    if ([[self.game cards] count] && !card.isChosen) {
        card.chosen = YES;
       [cardButton setBackgroundImage:[UIImage imageNamed:card.contents] forState:UIControlStateNormal];
    } else {
        if (cardButtonIndex % 2 == 0) {
            [cardButton setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
        } else {
            [cardButton setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
        }
        card.chosen = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
