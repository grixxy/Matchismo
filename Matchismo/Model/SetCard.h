//
//  SetCard.h
//  Matchismo
//
//  Created by Gregory on 3/31/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSNumber *number;
@property (strong, nonatomic) NSString *shading;
+(NSArray*) allColors;
+(NSArray*) allSymbols;
+(NSArray*) allNumbers;
+(NSArray*) allShadings;

@end
