//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Gregory Shukhter on 3/15/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property(nonatomic, strong) NSMutableArray* cards;
@property(nonatomic) int score;
@property(nonatomic) NSString* description;
@end

@implementation CardMatchingGame

-(NSMutableArray *) cards{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}


-(id) initWithCardCount:(NSUInteger) count usingDeck:(Deck *)deck{
    self = [super init];
    if(self){
        for(int i=0; i<count; i++){
            Card* card = [deck drawRandomCard];
            if(!card){
                self = nil;
            } else{
                self.cards[i] = card;
            }
        
        }
        
    }
    return self;
    
}

-(Card *) cardAtIndex:(NSUInteger) index{
    return (index<self.cards.count)? self.cards[index] :nil;
}

#define MATCH_BONUS 4;
#define MISMATCH_PENALTY 2;
#define FLIP_COST 1;

-(void)flipCardAtIndex:(NSUInteger) index{
    Card *card = [self cardAtIndex:index];
    if(!card.isUnplayable){
        if(!card.isFaceUp){
            self.score -= FLIP_COST;
            self.description = [NSString stringWithFormat:@"Flipped up %@ ", card.contents ];            
            for(Card* otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    int matchScore = [card match:@[otherCard]];
                    if(matchScore){
                        otherCard.unplayable = TRUE;
                        card.unplayable = TRUE;
                        int win = matchScore * MATCH_BONUS
                        self.score+=win;
                        self.description = [NSString stringWithFormat:@"Matched %@ && %@ for %d points", card.contents ,otherCard.contents, win];
                    
                    } else {
                        otherCard.faceUp = NO;
                        int lose = MISMATCH_PENALTY;
                        self.score -= lose;
                        self.description = [NSString stringWithFormat:@"%@ and %@ didn't match! %d points penalty!", card.contents ,otherCard.contents, lose];
                    }
                }
            }
        }
        card.faceUp = !card.isFaceUp;
    }
}

-(NSString *) description{
    if(!_description) _description = @"";
    return _description;
}

@end
