//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Gregory Shukhter on 3/15/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardMatchingGame()
@property(nonatomic, strong) NSMutableArray* cards;
@property(nonatomic) int score;
@property(nonatomic) NSString* description;
@property(nonatomic) NSUInteger numberOfCardsToCompare;
@end

@implementation CardMatchingGame

-(NSMutableArray *) cards{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}


-(id) initWithCardCount:(NSUInteger) count usingDeck:(Deck *)deck withComplexity:(NSUInteger) numberOfCardsToCompare {
    self = [super init];
    _numberOfCardsToCompare = numberOfCardsToCompare;
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
    NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init];
    if(!card.isUnplayable){
        if(!card.isFaceUp){
            self.score -= FLIP_COST;
            self.description = [NSString stringWithFormat:@"Flipped up %@ ", card.contents ];
            
            for(Card* otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [cardsToMatch addObject:otherCard];
                }
            }
            
            if(cardsToMatch.count==self.numberOfCardsToCompare-1){
                //time to count score!!!
                int matchScore = [card match:cardsToMatch];
                if(matchScore){
                    //unplayable TRUE
                    SEL unplayable = @selector(setUnplayable:);
                    [cardsToMatch makeObjectsPerformSelector:unplayable withObject:[NSNumber numberWithBool:YES]];
                    card.unplayable = YES;
                    int win = matchScore * MATCH_BONUS;
                    self.score+=win;
                    self.description = [NSString stringWithFormat:@"Matched %@,%@ for %d points",card,[cardsToMatch componentsJoinedByString:@", "] , win];
                
                } else {
                    SEL faceUp = @selector(setFaceUp:);
                    [cardsToMatch makeObjectsPerformSelector:faceUp withObject:NO];
                    int lose = MISMATCH_PENALTY;
                    self.score -= lose;
                    self.description = [NSString stringWithFormat:@"%@,%@ didn't match! %d points penalty!",card,[cardsToMatch componentsJoinedByString:@", "], lose];
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
