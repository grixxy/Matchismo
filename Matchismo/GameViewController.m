//
//  GameViewController.m
//  Matchismo
//
//  Created by Gregory on 3/28/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "GameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"


@interface GameViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) int flipCounts;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;



@end

@implementation GameViewController


-(CardMatchingGame *) game{
    if(!_game){
        NSUInteger complexity = 2;
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.startingCardCount intValue] usingDeck:[self createDeck] withComplexity:complexity];
        
    }
    return _game;
}

-(Deck*)createDeck{
    return nil;
}

- (IBAction)dealButton:(id)sender {
    self.game = nil;
    self.gameResult = nil;
    self.flipCounts = 0;
    [self updateUI];
}



-(void) updateUI{
    for(UICollectionViewCell* cell in [self.cardCollectionView visibleCells]){
        NSIndexPath * indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card * card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }

}


-(void) setFlipCounts:(int)flipCounts
{
    _flipCounts = flipCounts;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCounts];
}


- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    
    CGPoint tapLocation  = [gesture locationInView:self.cardCollectionView];
    NSIndexPath* indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if(indexPath){
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCounts++;
        [self updateUI];
        self.gameResult.score = self.game.score;
    }
    
}



-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateUI];
}

//----------------------Protocol Implementation
- (NSInteger)collectionView:(UICollectionView *)asker
     numberOfItemsInSection:(NSInteger)section
{
    return [self.startingCardCount integerValue];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.cardCollectionView dequeueReusableCellWithReuseIdentifier:[self reusableIdentifierCellName] forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}
-(NSString*) reusableIdentifierCellName{
    return nil;
}

-(void) updateCell:(UICollectionViewCell *)cell usingCard:(Card*) card {}


@end
