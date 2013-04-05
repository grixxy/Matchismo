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

@end

@implementation CardGameViewController


-(CardMatchingGame *) game{
    if(![super game]){
        NSUInteger complexity = 2;
        CardMatchingGame * l_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init] withComplexity:complexity];
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
    self.lastFlipLabel.text = [self textForLabelWithResults: self.game.lastActionResult];
}

-(NSString*) textForLabelWithResults:(ActionResult*) results {
    
    NSString* str;
    if(!results.cards){
        str = @"";
    } else if(results.scoreChange>0){
     str = [NSString stringWithFormat:@"Matched %@ for %d points",[results.cards componentsJoinedByString:@", "] , results.scoreChange];
    } else if(results.scoreChange<0){
        str = [NSString stringWithFormat:@"%@ didn't match! %d points penalty!",[results.cards componentsJoinedByString:@", "], results.scoreChange];
    } else {
     str = [NSString stringWithFormat:@"Flipped up %@ ", [results.cards lastObject] ];
    }
    return str;
    
}

@end
