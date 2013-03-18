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
            for(Card* otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    int matchScore = [card match:@[otherCard]];
                    if(matchScore){
                        otherCard.unplayable = TRUE;
                        card.unplayable = TRUE;
                        self.score+=matchScore * MATCH_BONUS;
                        self.description = [NSString stringWithFormat:@"Matched %@ && %@ for %d points", card, otherCard, (matchScore * MATCH_BONUS)];
                        [NSString stringWithFormat:@"%@", self.game];
                    
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

-(NSString *) description{
    return self.description;
}

@end
