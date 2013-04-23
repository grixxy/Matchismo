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
@property (strong, nonatomic)NSString* sortOrder;

@end

@implementation GameResultViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}
- (IBAction)selectorChange:(id)sender {
    [self updateUI];
}
- (IBAction)sortByDate:(id)sender {
    self.sortOrder = @"date";
    [self updateUI];
}
- (IBAction)sortByScore:(id)sender {
   self.sortOrder = @"score";
    [self updateUI];
}
- (IBAction)sortByDuration:(id)sender {
    self.sortOrder = @"duration";
    [self updateUI];
}

-(NSString*)sortOrder{
    if(!_sortOrder){
        _sortOrder = @"";
    }
    return _sortOrder;
}



-(void)updateUI{

    NSString* gameResultToDisplay;
    if([self.gameType selectedSegmentIndex]){
        gameResultToDisplay = [SetCard gameName];
    } else {
        gameResultToDisplay = [PlayingCard  gameName];
    }
    NSString* displayText = [gameResultToDisplay stringByAppendingString:@"\n"];
  
    for(GameResult *result in [GameResult allGameResultsForGame:gameResultToDisplay sortedBy:self.sortOrder]){
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
