//
//  Card.h
//  Matchismo
//
//  Created by Gregory on 3/7/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString * contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

-(int) match:(NSArray*) otherCards;
+(NSString*) gameName;

@end
