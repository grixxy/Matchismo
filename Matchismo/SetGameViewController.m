//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Gregory on 3/28/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController



-(CardMatchingGame *) game{
    if(![super game]){
        NSUInteger complexity = 3;
        CardMatchingGame * l_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[SetCardDeck alloc] init] withComplexity:complexity];
        [super setGame: l_game];
    }
    return [super game];
}

-(void) updateUI{
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if(card.isFaceUp){
            //face up
            cardButton.backgroundColor = [UIColor grayColor];
            
        } else {
            //face down
            cardButton.backgroundColor = [UIColor whiteColor];
        }
        
        //[cardButton setTitle:card.contents forState:UIControlStateSelected];
        //[cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.attributedText = [self textForLabelWithResults:self.game.lastActionResult];
    [self updateTextForButtons];
}

-(void) updateTextForButtons{
    for(UIButton *cardButton in self.cardButtons){
        SetCard *card = (SetCard*)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        NSAttributedString* cardText = [self getUIStringForCard:card];
        
        [cardButton setAttributedTitle:cardText forState:UIControlStateSelected];
        [cardButton setAttributedTitle:cardText forState:UIControlStateNormal];
        [cardButton setAttributedTitle:cardText forState:UIControlStateSelected|UIControlStateDisabled];
    }
    
}


-(NSAttributedString*) textForLabelWithResults:(ActionResult*) results {
    
    NSAttributedString* str;
    if(!results.cards){
        str = [[NSAttributedString alloc] initWithString:@""];
    } else if(results.scoreChange>0){
        NSMutableAttributedString * t_str = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
        [t_str appendAttributedString:[self joinCardStrings:results.cards]];
        NSString * t_str2 = [NSString stringWithFormat:@" for %d points",results.scoreChange];
        [t_str appendAttributedString:[[NSAttributedString alloc]initWithString:t_str2]];
        str = t_str;
    } else if(results.scoreChange<0){
        NSMutableAttributedString * t_str = [[NSMutableAttributedString alloc] init];
        [t_str appendAttributedString:[self joinCardStrings:results.cards]];
        NSString * t_str2 = [NSString stringWithFormat:@" didn't match %d points penalty",results.scoreChange];
        [t_str appendAttributedString:[[NSAttributedString alloc]initWithString:t_str2]];
        str = t_str;
    } else {
        NSMutableAttributedString * t_str = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
        [t_str appendAttributedString:[self joinCardStrings:results.cards]];
        str = t_str;
    }
    return str;
    
}

-(NSAttributedString*) joinCardStrings:(NSArray*)cards{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    for(SetCard *card in cards){
        [str appendAttributedString:[self getUIStringForCard:card]];
        if(cards.lastObject!=card){
           [str appendAttributedString:[[NSAttributedString alloc]initWithString:@","]];
        }
    }
    
    
    return str;
}

-(NSAttributedString*) getUIStringForCard:(SetCard* )card{
    NSString *cardString=@"";
    //symbol
    //number
    for(int i=0;i<[card.number intValue];i++){
       cardString = [cardString stringByAppendingString:card.symbol];
    }
    NSRange whole_range = NSMakeRange(0, cardString.length);
    //color red green purple
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:cardString];
    if([@"red" isEqualToString:card.color]){
      [str addAttribute:NSStrokeColorAttributeName value:[UIColor redColor] range:whole_range];
    } else if ([@"green" isEqualToString:card.color]){
        [str addAttribute:NSStrokeColorAttributeName value:[UIColor greenColor] range:whole_range];
    } else if ([@"purple" isEqualToString:card.color]){
        [str addAttribute:NSStrokeColorAttributeName value:[UIColor purpleColor] range:whole_range];
    }
   
    if([@"solid" isEqualToString:card.shading]){
        //[str addAttribute:NSStrokeColorAttributeName value:[UIColor redColor] range:whole_range];
        id color = [str attribute:NSStrokeColorAttributeName atIndex:0 effectiveRange:NULL];
        [str addAttribute:NSForegroundColorAttributeName value:color range:whole_range];
    } else if ([@"open" isEqualToString:card.shading]){
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:whole_range];
    } else if ([@"striped" isEqualToString:card.shading]){
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:whole_range];
    }
    [str addAttribute:NSStrokeWidthAttributeName value:[[NSNumber alloc]initWithFloat:-10.0] range:whole_range];
    //[str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:whole_range];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:whole_range];

    return str;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
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
