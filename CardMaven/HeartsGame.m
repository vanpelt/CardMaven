//
//  HeartsGame.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/8/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "HeartsGame.h"

@implementation HeartsGame : GameOfCards
@synthesize pointsTaken = _pointsTaken;
@synthesize currentPlayer = _currentPlayer;

- (GameOfCards *) init
{
    self = [super init];
    if (self) {
        self.cardsPerHand = 13;
    }
    return self;
}

-(PlayerOfCards *)currentPlayer
{
    if (!_currentPlayer) {
        NSUInteger i = [self.players indexOfObjectPassingTest:^(PlayerOfCards *player, NSUInteger idx, BOOL *stop) {
            if ([player.hand.cards indexOfObject:[[Card alloc] initWithCardName:@"2_of_clubs"]] == NSNotFound)
                return NO;
            else
                return YES;
        }];
        _currentPlayer = [self.players objectAtIndex:i];
    }
    return _currentPlayer;
}

-(BOOL)legalMoveForPlayer: (Card *)card player:(PlayerOfCards *)player
{   
    if (self.cardLead) {
        BOOL legal;
        if ([player.hand hasSuite:self.cardLead.suite])
            legal = [self.cardLead.suite isEqualToString:card.suite];
        else
            legal = YES;
        if (self.pointsTaken)
            return legal;
        else
            //The check for points should be in a method
            if ([self pointValue:card] > 0) {
                NSUInteger point = [player.hand.cards indexOfObjectPassingTest:^BOOL(Card *card, NSUInteger idx, BOOL *stop){
                    return [self pointValue:card] == 0;
                }];
                return point == NSNotFound;
            } else
                return legal;
    } else if (self.cardsPlayed > 0) {
        if (self.pointsTaken)
            return YES;
        else if ([self pointValue:card] > 0) {
            NSUInteger point = [player.hand.cards indexOfObjectPassingTest:^BOOL(Card *card, NSUInteger idx, BOOL *stop){
                return [self pointValue:card] == 0;
            }];
            return point == NSNotFound;
        } else
            return YES;
    } else {
        //We need this for the start of the game...
        return [card.cardName isEqualToString:@"2_of_clubs"];
    }
}

- (BOOL)playCardForPlayer:(Card *)card player:(PlayerOfCards *)player
{
    if ([self legalMoveForPlayer:card player:player]) {
        BOOL played = [super playCardForPlayer:card player:player];
        //pointsTaken should be a method that sums players points...
        if (played && ([card.suite isEqualToString:@"hearts"] || [card.cardName isEqualToString:@"queen_of_spades"])) {
            self.pointsTaken = YES;
        }
            
        return played;
    }
    return NO;
}

- (Card *)playRandomCardForPlayer: (PlayerOfCards *)player
{
    Card *cardPlayed;
    for (Card *card in [self shuffleCards: player.hand.cards]) {
        cardPlayed = card;
        if ([self playCardForPlayer:card player:player])
            break;
        else 
            cardPlayed = nil;
    }
    return cardPlayed;
}

- (BOOL)handComplete
{
    return (self.cardsPlayed > 0 && self.cardsPlayed % 4 == 0);
}

- (PlayerOfCards *)winner
{
    NSMutableArray *sortedPlayers = [self.players mutableCopy];
    if ([self handComplete]  && ![self startOfHand]) {
        [sortedPlayers sortUsingSelector:@selector(compare:)];
        return [sortedPlayers lastObject];
    }
    return [super winner];
}

- (NSNumber *)scoreOfCardInPlay: (Card *)card
{
    if ([self.cardLead.suite isEqualToString:card.suite]) {
        return [NSNumber numberWithInt:card.faceValue];
    } else 
        return [NSNumber numberWithInt:0];
}

- (int)pointValue: (Card *)card
{
    if ([card.suite isEqualToString:@"hearts"])
        return card.faceValue;
    else if ([card.cardName isEqualToString:@"queen_of_spades"])
        return 13;
    else 
        return 0;
}
@end
