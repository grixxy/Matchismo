//
//  ActionResult.h
//  Matchismo
//
//  Created by Gregory on 4/4/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface ActionResult : NSObject


@property (nonatomic) NSArray* matchedCards;

@property (nonatomic) NSMutableArray* flippedCards;
@property (nonatomic) int scoreChange;

-(void)addFlippedCard:(Card *)card;
-(void)removeFlippedCard:(Card *)card;

@end
