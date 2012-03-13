//
//  HandOfCards.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "HandOfCards.h"

@implementation HandOfCards

@synthesize cards = _cards;
@synthesize player = _player;

-(HandOfCards *)initWithPlayerAndCards: (PlayerOfCards *)player cards:(NSMutableArray *)cards
{
    self = [super init];

    [cards sortUsingSelector:@selector(compare:)];
    self.cards = cards;
    self.player = player;
    return self;
}
    
-(Card *)play: (NSString *)cardName
{
    Card * card = [[Card alloc] initWithCardName:cardName];
    [self.cards removeObject:card];
    self.player.cardsInPlay = [[NSArray alloc] initWithObjects:card,nil];
    return card;
}

-(BOOL)hasSuite: (NSString *)suite
{
    NSUInteger index = [self.cards indexOfObjectPassingTest:^(Card *obj,NSUInteger idx,BOOL *stop){
        return [obj.suite isEqualToString:suite];
    }];
    return index != NSNotFound;
}

@end
