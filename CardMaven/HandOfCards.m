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
@synthesize owner = _owner;

-(HandOfCards *)initWithOwnerAndCards: (NSString *)owner cards:(NSMutableArray *)cards
{
    self = [super init];
    self.cards = cards;
    self.owner = owner;
    return self;
}
@end
