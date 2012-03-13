//
//  HandOfCards.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerOfCards.h"
#import "Card.h"
@class PlayerOfCards;
@interface HandOfCards : NSObject
@property (strong, nonatomic) NSMutableArray* cards;
@property (strong, nonatomic) PlayerOfCards* player;

-(HandOfCards *)initWithPlayerAndCards: (PlayerOfCards *)player cards:(NSMutableArray *)cards;
-(Card *)play: (NSString *)cardName;
-(BOOL)hasSuite: (NSString *)suite;
@end
