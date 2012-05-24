//
//  PlayerOfCards.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/8/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandOfCards.h"
#import "GameOfCards.h"
@class GameOfCards;
@class HandOfCards;
@interface PlayerOfCards : NSObject
@property (strong, nonatomic) HandOfCards *hand;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *cardsInPlay;
@property (strong, nonatomic) GameOfCards *game;
@property (nonatomic) int score;
@property (nonatomic) BOOL bot;
-(NSString *)play: (NSString *)cardName;
-(PlayerOfCards *) initWithGameAndName: (GameOfCards*) game name:(NSString *) name;
-(PlayerOfCards *) initAsBotWithGameAndName: (GameOfCards*) game name:(NSString *) name;
-(NSString *)displayName;
-(BOOL) won;

@end
