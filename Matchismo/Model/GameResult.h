//
//  GameResult.h
//  Matchismo
//
//  Created by Gregory Shukhter on 4/7/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject
@property (readonly, nonatomic) NSDate* start;
@property (readonly, nonatomic) NSDate* end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic)int score;
-(id) initWithGameName:(NSString*)gameName;
+(NSArray*) allGameResultsForGame:(NSString*)gameName;
+(NSArray*) allGameResultsForGame:(NSString*)gameName sortedBy:(NSString*) sortOrder;
@end
