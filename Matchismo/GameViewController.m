//
//  GameViewController.m
//  Matchismo
//
//  Created by Gregory on 3/28/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "GameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"


@interface GameViewController ()
@property (nonatomic) int flipCounts;


@end

@implementation GameViewController

- (IBAction)dealButton:(id)sender {
    self.game = nil;
    self.gameResult = nil;
    self.flipCounts = 0;
    [self updateUI];
}



-(void) updateUI{}


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
    self.gameResult.score = self.game.score;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateUI];
}


@end
