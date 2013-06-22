//
//  Deck.h
//  Matchismo
//
//  Created by Gregory on 3/7/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;
-(NSUInteger)numberOfCardsInDeck;
@end
