//
//  GameViewController.h
//  Matchismo
//
//  Created by Gregory on 3/28/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface GameViewController : UIViewController
@property (nonatomic, readwrite, weak) IBOutlet UILabel *lastFlipLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *flipsLabel;

@property (nonatomic, readwrite, strong) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic, readwrite, strong) CardMatchingGame *game;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *scoreLabel;
@property(strong, nonatomic) GameResult * gameResult;

@end
