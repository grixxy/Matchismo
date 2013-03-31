//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Gregory on 3/28/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController



-(CardMatchingGame *) game{
    if(![super game]){
        NSUInteger complexity = 3;
        CardMatchingGame * l_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[SetCardDeck alloc] init] withComplexity:complexity];
        [super setGame: l_game];
    }
    return [super game];
}

-(void) updateUI{
    UIImage *cardBackImage = [UIImage imageNamed:@"Untitled.png"];
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if(!card.isFaceUp){
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            UIEdgeInsets insets = UIEdgeInsetsMake(2,2,3,3);
            cardButton.imageEdgeInsets = insets;
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = self.game.description;
    
}











- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
