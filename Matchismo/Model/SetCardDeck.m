//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Gregory on 3/31/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init {
    self = [super init];
    if (self) {
        for(NSNumber* number in [SetCard allNumbers]){
            for(NSString* color in [SetCard allColors]){
                for(NSString * symbol in [SetCard allSymbols]){
                    for(NSString* shading in [SetCard allShadings]){
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.color = color;
                        card.symbol = symbol;
                        card.shading = shading;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
        
    }
    return self;
}


@end
