//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Gregory on 3/7/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCounts;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardGameViewController

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

-(void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    for(UIButton *cardButton in cardButtons){
        Card *card = [self.deck drawRandomCard];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
    }
}

-(void) setFlipCounts:(int)flipCounts
{
    _flipCounts = flipCounts;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCounts];
}

- (IBAction)flipCard:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.flipCounts++;
}

@end
