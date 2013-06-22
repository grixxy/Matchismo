//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Gregory Shukhter on 3/15/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "CardMatchingGame.h"
#import "ActionResult.h"


@interface CardMatchingGame()
@property(nonatomic) int score;
@property(nonatomic) NSString* description;
@property(nonatomic) NSUInteger numberOfCardsToCompare;
@property(nonatomic) ActionResult* lastActionResult;
@property(nonatomic) Deck* deck;

@end

@implementation CardMatchingGame

-(NSMutableArray *) cards{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(ActionResult*) lastActionResult{
    if(!_lastActionResult)_lastActionResult = [[ActionResult alloc] init];
    return _lastActionResult;
}

-(id) initWithCardCount:(NSUInteger) count usingDeck:(Deck *)deck withComplexity:(NSUInteger) numberOfCardsToCompare {
    self = [super init];
    self.deck = deck;
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

-(BOOL)drawAdditionalCards:(NSUInteger) numberOfCards{
    BOOL noMoreCards = false;
    for(int i=0;i<numberOfCards;i++){
        Card* card = [self.deck drawRandomCard];
        if(card){
            [self.cards addObject:card];
        } else {
            noMoreCards = true;
        }
    }
    return noMoreCards;
}

-(BOOL) deckHasMoreCards{
    return [self.deck numberOfCardsInDeck]>0;
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
            self.lastActionResult.cards = @[card];
            self.lastActionResult.scoreChange = 0;
            
            for(Card* otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [cardsToMatch addObject:otherCard];
                }
            }
            NSMutableArray* allCards =[[NSMutableArray alloc]initWithArray:cardsToMatch];
            [allCards addObject:card];
            
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
                    self.lastActionResult.cards = allCards;
                    self.lastActionResult.scoreChange = win;
                
                } else {
                    SEL faceUp = @selector(setFaceUp:);
                    [cardsToMatch makeObjectsPerformSelector:faceUp withObject:NO];
                    int lose = MISMATCH_PENALTY;
                    self.score -= lose;
                    self.lastActionResult.cards = allCards;
                    self.lastActionResult.scoreChange = -lose;
                    
                }
            }
            
        }
        card.faceUp = !card.isFaceUp;
    }
}

-(NSArray*) notPlayableCards{
    NSMutableArray* cardIndexes;
    for(Card* card in self.cards){
        if(card.isUnplayable){
            if(!cardIndexes){
                cardIndexes = [[NSMutableArray alloc] init];
            }
            [cardIndexes addObject:[[NSNumber alloc] initWithInteger:[self.cards indexOfObject:card]]];
        }
    }
    return cardIndexes;
}



-(void) deleteCardsAtIndexes:(NSArray*)indexes{
    NSMutableArray* toDelete;
    for(NSNumber* index in indexes){
        if(!toDelete){
            toDelete = [[NSMutableArray alloc] init];
        }
        [toDelete addObject:[self.cards objectAtIndex:[index integerValue]]];
    }
    [self.cards removeObjectsInArray:toDelete];
}



-(NSString *) description{
    if(!_description) _description = @"";
    return _description;
}

@end
