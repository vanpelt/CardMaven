//
//  GameViewController.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/6/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation GameViewController
@synthesize infoButton = _infoButton;
@synthesize cardGame = _cardGame;
@synthesize gameStatus = _gameStatus;
@synthesize handOfCards = _handOfCards;

- (GameStatusViewController *) gameStatus
{
    if(!_gameStatus)
        _gameStatus = [[self storyboard] instantiateViewControllerWithIdentifier: @"game_status"];
    return _gameStatus;
}

- (HandOfCardsViewController *) handOfCards
{
    if(!_handOfCards)
        _handOfCards = [[self storyboard] instantiateViewControllerWithIdentifier: @"hand_of_cards"];
    return _handOfCards;
}

- (IBAction)newGame:(id)sender {
    [self cancel:sender];
    [self.navigationController popViewControllerAnimated:YES];
    //[self.parentViewController.navigationController pushViewController:[[self storyboard] instantiateViewControllerWithIdentifier: @"new_game"] animated:YES];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)nextMove {
    if (![self.cardGame handComplete] || [self.cardGame startOfHand]) {
        PlayerOfCards *currentPlayer = [self.cardGame currentPlayer];
        if (currentPlayer.bot) {
            NSLog(@"Playing random card for %@", currentPlayer.name);
            [self.cardGame playRandomCardForPlayer:currentPlayer];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextMove:) userInfo:nil repeats:NO];
            //[self nextMove];       
        }
        
        if (self.cardGame.cardsInPlay.count == 1 || [self.cardGame startOfHand]) {
            [self.handOfCards drawCards];
        }
    }
    [self.gameStatus draw];
}

- (void)nextMove:(id)sender
{
    [self nextMove];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //We'll want to add everyone here...
    PlayerOfCards *me = [[PlayerOfCards alloc] initWithGameAndName: self.cardGame name:[[UIDevice currentDevice] name]];
    [self.cardGame addPlayer:me];
    
    //We need to ask the current game WTF...
    [self.cardGame addPlayer:[[PlayerOfCards alloc] initAsBotWithGameAndName: self.cardGame name:@"Bob"]];
    [self.cardGame addPlayer:[[PlayerOfCards alloc] initAsBotWithGameAndName: self.cardGame name:@"Frank"]];
    [self.cardGame addPlayer:[[PlayerOfCards alloc] initAsBotWithGameAndName: self.cardGame name:@"Willy"]];
    
    [self.cardGame shuffle];
    [self.cardGame deal];
    
    [self addChildViewController:self.handOfCards];
    self.handOfCards.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.handOfCards.view];
    
    [self addChildViewController:self.gameStatus];
    self.gameStatus.view.center = CGPointMake(160,620);
    self.gameStatus.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.gameStatus.view];
    [self.view bringSubviewToFront:self.infoButton];
    [self nextMove];
}

- (void)viewDidUnload
{
    [self setInfoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    if (orientation == UIInterfaceOrientationPortrait)
        self.gameStatus.view.center = CGPointMake(240,620);
    else
        self.gameStatus.view.center = CGPointMake(160,460);

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [self.gameStatus draw];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
