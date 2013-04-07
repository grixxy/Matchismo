//
//  GameResult.m
//  Matchismo
//
//  Created by Gregory Shukhter on 4/7/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "GameResult.h"
@interface GameResult()
@property (readwrite, nonatomic) NSDate* start;
@property (readwrite, nonatomic) NSDate* end;
@property (nonatomic) NSString *gameName;
@end


@implementation GameResult

#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

+(NSArray*) allGameResultsForGame:(NSString*) gameName{
    NSMutableArray * allGameResults = [[NSMutableArray alloc]init];
    for(id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:gameName] allValues]){
        GameResult* gameResult = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:gameResult];
    }
    return allGameResults;
}

-(id) initFromPropertyList:(id)plist{
    self = [self init];
    if(self){
        if([plist isKindOfClass:[NSDictionary class]]){
            NSDictionary *resultDictionary = (NSDictionary*)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY]intValue];
            if(!_start||!_end) self = nil;
        }
    }
    return self;
}

-(id) initWithGameName:(NSString*) gameName {

    self = [super init];
    if(self){
        _start = [NSDate date];
        _end = _start;
        _gameName = gameName;
    }
    
    return self;
    
}

- (NSTimeInterval) duration{
    return [self.end timeIntervalSinceDate:self.start];
}

-(void) setScore:(int)score{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}



-(void) synchronize{
    
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey: self.gameName] mutableCopy];
    if(!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:self.gameName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



                                       
-(id) asPropertyList{
    return @{START_KEY:self.start, END_KEY:self.end, SCORE_KEY: @(self.score)};
}

@end
