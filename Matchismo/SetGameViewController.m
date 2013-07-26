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
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet SetCardView *card;
@property (weak, nonatomic) IBOutlet UITextView *lastActionText;


@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSArray *pickedCards;

@end

@implementation SetGameViewController

- (IBAction)add3Cards:(id)sender {
    [self.game drawAdditionalCards:3];
    [self.cardCollectionView reloadData];
    NSUInteger indexes[] = {0,[self.game.cards count]-1};
    NSIndexPath * lastPath = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
    [self.cardCollectionView scrollToItemAtIndexPath:lastPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [self updateUI];
    
}


-(CardMatchingGame *) game{
    if(![super game]){
        NSUInteger complexity = 3;
        CardMatchingGame * l_game = [[CardMatchingGame alloc] initWithCardCount: [self.startingCardCount integerValue] usingDeck:[[SetCardDeck alloc] init] withComplexity:complexity];
        [super setGame: l_game];
    }
    return [super game];
}


-(GameResult*) gameResult {
    if(!super.gameResult){
        super.gameResult = [[GameResult alloc] initWithGameName:[SetCard gameName]];
    }
    return super.gameResult;
}



#define DEFAULT_SET_CARDS 10
-(NSNumber*) startingCardCount {
    if(!super.startingCardCount){
        super.startingCardCount = [[NSNumber alloc] initWithInt:DEFAULT_SET_CARDS];
    }
    return super.startingCardCount;
}



-(void) updateUI{
    [self removeUnplayableCards];
    [super updateUI];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateGameStatus];
    
    [self.addButton setEnabled:[self.game deckHasMoreCards]];
    [self.addButton setAlpha:[self.game deckHasMoreCards]?1:0.3];
    
}

-(void) updateCell:(UICollectionViewCell *)cell usingCard:(Card*) card{
    if([cell isKindOfClass:[SetCardCollectionViewCell class]]){
        SetCardView* setCardView = ((SetCardCollectionViewCell*)cell).setCardView;
        if([card isKindOfClass:[SetCard class]]){
            SetCard* setCard = (SetCard*)card;
            [self updateSetCardView:setCardView withCard:setCard ignoringAlpha:FALSE];
        }
    }
    
}

-(void)updateSetCardView:(SetCardView*)setCardView withCard:(SetCard*)setCard ignoringAlpha: (BOOL)ignoreAlpha{
    setCardView.shading = setCard.shading;
    setCardView.color = [self mapColor:setCard.color];
    setCardView.shape = [self mapShape:setCard.symbol];
    setCardView.numberOfShapes = [setCard.number intValue];
    if(!ignoreAlpha)
       setCardView.alpha = setCard.isFaceUp ? 0.3: 1.0;
    else setCardView.alpha=1;

}


-(void)removeUnplayableCards{
    NSArray* indexes = [self.game notPlayableCards];
    if(indexes) {
     [self.game deleteCardsAtIndexes:indexes];
     indexes = [self getIndexPathArrayFromIndexes:indexes];
     [self.cardCollectionView deleteItemsAtIndexPaths:indexes];
    }
}

-(NSArray*)getIndexPathArrayFromIndexes:(NSArray*)indexes{
    NSMutableArray* indexPaths;
    for(NSNumber* index in indexes){
        if(!indexPaths) indexPaths = [[NSMutableArray alloc] init] ;
        NSUInteger indexArr[] = {0,[index integerValue]};
        NSIndexPath* ip = [NSIndexPath indexPathWithIndexes:indexArr length:2];
        [indexPaths addObject:ip];
    }
    return indexPaths;
}




-(UIColor*) mapColor:(NSString*)color{
    if([color isEqualToString:@"green"]){
        return [UIColor greenColor];
    }
    if([color isEqualToString:@"red"]){
        return [UIColor redColor];
    }
    if([color isEqualToString:@"purple"]){
        return [UIColor purpleColor];
    }
    return NULL;
}


-(NSString*) mapShape:(NSString*)shape{
    if([shape isEqualToString:@"▲"]){
        return @"squiggle";
    }
    if([shape isEqualToString:@"●"]){
        return @"oval";
    }
    if([shape isEqualToString:@"■"]){
        return @"diamond";
    }
    return nil;
}

-(void)updateGameStatus {
    //update text
    ActionResult* results = self.game.lastActionResult;
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@""];
   if(results.scoreChange>0){
        NSString * t_str = [NSString stringWithFormat:@"Matched for %d points:",results.scoreChange];
        str = [[NSMutableAttributedString alloc] initWithString:t_str];
       [self updateCardResultView:results.matchedCards];
    } else if(results.scoreChange<0){
        NSString * t_str = [NSString stringWithFormat:@"Penalty %d for not matching cards:",results.scoreChange];
        str = [[NSMutableAttributedString alloc] initWithString:t_str];
        [self updateCardResultView:results.matchedCards];
    } else if(results.scoreChange==0){
        str = [[NSMutableAttributedString alloc] initWithString:@"Flipped up :"];
        [self updateCardResultView:results.flippedCards];
        
    } 
    self.lastActionText.attributedText = str;
    
    //show cards
    
    
    
}


-(void) updateCardResultView:(NSArray*) cards {

    for(int i=0;i<self.pickedCards.count;i++){
        SetCardView* setCardView = (SetCardView*)[self getPickedCardByTagIndex:i];
        
        if(i<cards.count){
            [self updateSetCardView:setCardView withCard:[cards objectAtIndex:i] ignoringAlpha:TRUE];
        } else{
            [self setBlankCard:setCardView];
        }
        
    }

}

-(SetCardView*) getPickedCardByTagIndex:(int)index{
    for(SetCardView* setCardView in self.pickedCards){
        if([setCardView tag] == index) return setCardView;
    }
    return nil;
}

-(void) setBlankCard:(SetCardView*)setCardView{
    setCardView.shading = nil;
    setCardView.color =  nil;
    setCardView.shape =  nil;
    setCardView.numberOfShapes =  0;

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
        id color = [str attribute:NSStrokeColorAttributeName atIndex:0 effectiveRange:NULL];
        [str addAttribute:NSForegroundColorAttributeName value:color range:whole_range];
    } else if ([@"open" isEqualToString:card.shading]){
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:whole_range];
    } else if ([@"stripe" isEqualToString:card.shading]){
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:whole_range];
    }
    [str addAttribute:NSStrokeWidthAttributeName value:[[NSNumber alloc]initWithFloat:-10.0] range:whole_range];
    //[str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:whole_range];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:whole_range];

    return str;
    
}

-(NSString*) reusableIdentifierCellName{
    return @"SetCard";
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
