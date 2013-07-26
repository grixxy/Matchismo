//
//  ActionResult.m
//  Matchismo
//
//  Created by Gregory on 4/4/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "ActionResult.h"

@implementation ActionResult

-(void)addFlippedCard:(Card *)card{
    if(!self.flippedCards){
        self.flippedCards = [[NSMutableArray alloc] init];
    }
    [self.flippedCards addObject:card];
}

-(void)removeFlippedCard:(Card *)card{
    if(self.flippedCards){
        [self.flippedCards removeObject:card];
    }
    
}


@end
