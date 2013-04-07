//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Gregory Shukhter on 4/6/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"
#import "PlayingCard.h"
#import "SetCard.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;

@end

@implementation GameResultViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}
- (IBAction)selectorChange:(id)sender {
    [self updateUI];
}

-(void)updateUI{

    NSString* gameResultToDisplay;
    if([self.gameType selectedSegmentIndex]){
        gameResultToDisplay = [PlayingCard gameName];
    } else {
        gameResultToDisplay = [SetCard gameName];
    }
    NSString* displayText = [gameResultToDisplay stringByAppendingString:@"\n"];
    
    for(GameResult *result in [GameResult allGameResultsForGame:gameResultToDisplay]){
        displayText = [displayText stringByAppendingFormat:@"Score %d (%@, %0g)\n", result.score, result.end, round(result.duration)];
    }
    self.display.text = displayText;
}
-(void) setup{

}

- (void)awakeFromNib{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   [self setup];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
