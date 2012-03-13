//
//  GameOfCards.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandOfCards.h"
#import "Card.h"

@class PlayerOfCards;
@class HandOfCards;
@interface GameOfCards : NSObject
@property (strong, nonatomic) NSMutableArray *hands;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) PlayerOfCards *currentPlayer;
@property (strong, nonatomic) NSMutableArray *cardsInPlay;
@property (nonatomic) int cardsPerHand;
@property (nonatomic) int cardsPlayed;
@property (nonatomic) BOOL startOfHand;

- (void)shuffle;
- (void)deal;
- (void)addPlayer:(PlayerOfCards *)player;
- (HandOfCards *)myHand;
- (PlayerOfCards *)me;
- (BOOL)legalMoveForPlayer: (Card *)card player:(PlayerOfCards *) player;
- (BOOL)playCardForPlayer: (Card *)card player:(PlayerOfCards *) player;
- (Card *)playRandomCardForPlayer: (PlayerOfCards *) player;
- (Card *)lastCardPlayed;
- (Card *)cardLead;
- (void)findNextPlayer;
- (void)newHand;
- (BOOL)handComplete;
- (NSNumber *)scoreOfCardInPlay: (Card *)card;
- (NSMutableArray *)shuffleCards: (NSMutableArray *)cards;
- (PlayerOfCards *)winner;
- (int)pointValue: (Card *) card;
@end
