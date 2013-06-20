//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Gregory Shukhter on 3/15/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "ActionResult.h"

@interface CardMatchingGame : NSObject

-(id) initWithCardCount:(NSUInteger) cardCount usingDeck:(Deck *)deck withComplexity: (NSUInteger) numberOfCardsToCompare ;

-(void)flipCardAtIndex:(NSUInteger) index;

-(Card *) cardAtIndex:(NSUInteger) index;

@property(nonatomic, strong) NSMutableArray* cards;
@property(nonatomic, readonly) int score;
@property(nonatomic, readonly) ActionResult* lastActionResult;


@end
