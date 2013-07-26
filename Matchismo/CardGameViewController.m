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
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface CardGameViewController ()


@end

@implementation CardGameViewController

-(Deck*)createDeck{
    return [[PlayingCardDeck alloc] init];
}

-(GameResult*) gameResult {
    if(!super.gameResult){
        super.gameResult = [[GameResult alloc] initWithGameName:[PlayingCard gameName]];
    }
    return super.gameResult;
}

#define DEFAULT_PLAY_CARDS 22
-(NSNumber*) startingCardCount {
    if(!super.startingCardCount){
        super.startingCardCount = [[NSNumber alloc] initWithInt:DEFAULT_PLAY_CARDS];
    }
    return super.startingCardCount;
}

-(void) updateCell:(UICollectionViewCell *)cell usingCard:(Card*) card{
    if([cell isKindOfClass:[PlayingCardCollectionViewCell class]]){
        PlayingCardView* playingCardView = ((PlayingCardCollectionViewCell*)cell).playingCardView;
        if([card isKindOfClass:[PlayingCard class]]){
            PlayingCard* playingCard = (PlayingCard*) card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3: 1.0;
        }
    }

}



-(void) updateUI{
    [super updateUI];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = [self textForLabelWithResults: self.game.lastActionResult];
}

-(NSString*) textForLabelWithResults:(ActionResult*) results {
    
    NSString* str =  @"";

    if(results.scoreChange>0){
     str = [NSString stringWithFormat:@"Matched %@ for %d points",[results.matchedCards componentsJoinedByString:@", "] , results.scoreChange];
    } else if(results.scoreChange<0){
        str = [NSString stringWithFormat:@"%@ didn't match! %d points penalty!",[results.matchedCards  componentsJoinedByString:@", "], results.scoreChange];
    } else if(results.scoreChange==0) {
     str = [NSString stringWithFormat:@"Flipped up %@ ", [results.flippedCards lastObject] ];
    } 
    return str;
    
}
-(NSString*) reusableIdentifierCellName{
    return @"PlayingCard";
}



@end
