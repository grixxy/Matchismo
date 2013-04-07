//
//  SetCard.m
//  Matchismo
//
//  Created by Gregory on 3/31/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
+(NSArray*) allColors{
    return @[@"red",@"green",@"purple"];
}
+(NSArray*) allSymbols{
    return @[@"▲", @"■", @"●"];
}

+(NSString*)gameName{
    return @"SetGame";
}

+(NSArray*) allNumbers{
    return [[NSArray alloc] initWithObjects:[[NSNumber alloc]initWithInt:1],[[NSNumber alloc]initWithInt:2],[[NSNumber alloc]initWithInt:3], nil];
 }
+(NSArray*) allShadings{
 return @[@"solid", @"open", @"striped"];
}

-(int) match:(NSArray *)otherCards{
    int match = 10;
    NSMutableSet *uniqueColors = [[NSMutableSet alloc] initWithObjects:self.color, nil];
    NSMutableSet *uniqueSymbols = [[NSMutableSet alloc] initWithObjects:self.symbol, nil];
    NSMutableSet *uniqueNumbers = [[NSMutableSet alloc] initWithObjects:self.number, nil];
    NSMutableSet *uniqueChadings = [[NSMutableSet alloc] initWithObjects:self.shading, nil];
    
    for(SetCard *otherCard in otherCards){
     [uniqueColors addObject:otherCard.color];
     [uniqueSymbols addObject:otherCard.symbol];
     [uniqueNumbers addObject:otherCard.number];
     [uniqueChadings addObject:otherCard.shading];
    }
    int numberOfCardsInSet = otherCards.count+1;
    if(uniqueColors.count!=1 && uniqueColors.count!=numberOfCardsInSet){
        match = 0;
    }
    if(uniqueSymbols.count!=1 && uniqueSymbols.count!=numberOfCardsInSet){
        match = 0;
    }
    if(uniqueNumbers.count!=1 && uniqueNumbers.count!=numberOfCardsInSet){
        match = 0;
    }
    if(uniqueChadings.count!=1 && uniqueChadings.count!=numberOfCardsInSet){
        match = 0;
    }
    
    return match;
    
}

@end
