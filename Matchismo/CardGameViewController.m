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
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardSelector;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCounts;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation CardGameViewController
- (IBAction)dealButton:(id)sender {
    self.game = nil;
    self.flipCounts = 0;
    [self updateUI];
}


-(CardMatchingGame *) game{
    if(!_game){
        NSUInteger complexity = self.cardSelector.selectedSegmentIndex==0?2:3;
        NSLog(@"complexity is %d", complexity);
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init] withComplexity:complexity];
    }
    return _game;
}

-(void) updateUI{
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = self.game.description;

}


-(void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
}

-(void) setFlipCounts:(int)flipCounts
{
    _flipCounts = flipCounts;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCounts];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCounts++;
    [self updateUI];
    
}




@end
