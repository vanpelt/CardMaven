//
//  PlayerOfCards.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/8/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "PlayerOfCards.h"

@implementation PlayerOfCards
@synthesize hand = _hand;
@synthesize name = _name;
@synthesize cardsInPlay = _cardsInPlay;
@synthesize bot = _bot;
@synthesize game = _game;
@synthesize score = _score;

-(PlayerOfCards *) initWithGameAndName: (GameOfCards *) game name: (NSString *) name
{
    self = [super init];
    if(self) {
        self.game = game;
        self.name = name;
    }
    return self;
}

-(PlayerOfCards *) initAsBotWithGameAndName: (GameOfCards *) game name: (NSString *) name
{
    self = [self initWithGameAndName:game name: name];
    if(self)
        self.bot = YES;
    return self;
}

-(BOOL)won
{
    return [[self.game winner] isEqual:self];
}

-(Card *)play: (NSString *)cardName
{
    return [self.hand play: cardName];
}

-(NSString *)displayName
{
    //We could be smarter about this...
    return [self.name substringWithRange: NSMakeRange(0, MIN(self.name.length, 15))];
}

-(NSNumber *) scoreOfCardsInPlay
{
    int score = 0;
    for (Card *card in self.cardsInPlay) {
        score += [[self.game scoreOfCardInPlay:card] intValue];
    }
    return [NSNumber numberWithInt:score];
}
            
-(NSComparisonResult)compare: (PlayerOfCards *)against
{
    return [[self scoreOfCardsInPlay] compare: [against scoreOfCardsInPlay]];
}

- (BOOL) isEqual:(PlayerOfCards *)object
{
    return [self.name isEqualToString:object.name];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<PlayerOfCards: %@, cardsInPlay:%@>", self.name, self.cardsInPlay];
}
@end
