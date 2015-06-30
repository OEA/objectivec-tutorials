//
//  ViewController.m
//  Card Game
//
//  Created by Ömer Emre Aslan on 29/06/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *cardButton;
@property (strong, nonatomic) IBOutlet UILabel *labelCount;
@property (strong, nonatomic) PlayingCardDeck *cardDeck;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_cardDeck)
        _cardDeck = [PlayingCardDeck new];
    PlayingCardDeck *sharedInstance = [PlayingCardDeck new];
    PlayingCardDeck *cardDeck1 = [[PlayingCardDeck alloc] init];
    PlayingCardDeck *cardDeck2 = [sharedInstance copy];
    NSLog(@"sharedInstance: %@ c1: %@ c2: %@",sharedInstance,cardDeck1,cardDeck2);
}
- (IBAction)cardButtonTapped:(id)sender
{
    [self drawRandomCard];
}

- (void)drawRandomCard
{
    if ([self.cardDeck.cards count]) {
    Card *card = [self.cardDeck drawRandomCard]; 
    self.labelCount.text = [NSString stringWithFormat:@"There are %li cards in deck", [self.cardDeck.cards count]];
    [self.cardButton setTitle:[NSString stringWithFormat:@"%@",card.contents] forState:UIControlStateNormal];
    } else {
        self.labelCount.text = @"There is no any card in deck!";
        [self.cardButton setTitle:@":(" forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self drawRandomCard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
