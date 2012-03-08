//
//  GameOfCards.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "GameOfCards.h"

@interface GameOfCards ()
@property (strong, readonly) NSDictionary *cardNames;
@end

@implementation GameOfCards
@synthesize cardNames = _cardNames;
@synthesize cards = _cards;
@synthesize hands = _hands;

- (void)deal:(NSArray *) owners
{
    self.hands = [[NSMutableArray alloc] initWithCapacity:owners.count];
    for (NSString *owner in owners) {
        [self.hands addObject:[[HandOfCards alloc] initWithOwnerAndCards:owner cards:[self drawCardsForOwner:14]]];
    }
}

- (NSMutableArray *)drawCardsForOwner: (int) howMany
{
    NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity:howMany];
    for (int i = 0; i < howMany; i++) {
        [cards addObject:[self.cards objectAtIndex:self.cards.count -1]];
        [self.cards removeLastObject];
    }
    return cards;
}

- (void)shuffle
{
    const int n = self.cards.count;
    for (int i = 0; i < n; i++) {
        int j = (int) (drand48()*n);
        if (i != j)
            [self.cards exchangeObjectAtIndex: i
                       withObjectAtIndex: j];
    }
}

- (NSMutableArray *)cards
{   
    if(!_cards) {
        _cards = [[NSMutableArray alloc] initWithCapacity:52];
        [_cards addObjectsFromArray: [self.cardNames objectForKey:@"diamonds"]];
        [_cards addObjectsFromArray: [self.cardNames objectForKey:@"clubs"]];
        [_cards addObjectsFromArray: [self.cardNames objectForKey:@"hearts"]];
        [_cards addObjectsFromArray: [self.cardNames objectForKey:@"spades"]];
    }
    return _cards;
}

- (NSDictionary *)cardNames 
{
    if(!_cardNames) {
        _cardNames  = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [[NSArray alloc] initWithObjects:
                       @"1_of_diamonds",
                       @"2_of_diamonds",
                       @"3_of_diamonds",
                       @"4_of_diamonds",
                       @"5_of_diamonds",
                       @"6_of_diamonds",
                       @"7_of_diamonds",
                       @"8_of_diamonds",
                       @"9_of_diamonds",
                       @"10_of_diamonds",
                       @"jack_of_diamonds",
                       @"queen_of_diamonds",
                       @"king_of_diamonds",
                       @"ace_of_diamonds",
                       nil
                       ],@"diamonds", 
                   [[NSArray alloc] initWithObjects:
                    @"1_of_clubs",
                    @"2_of_clubs",
                    @"3_of_clubs",
                    @"4_of_clubs",
                    @"5_of_clubs",
                    @"6_of_clubs",
                    @"7_of_clubs",
                    @"8_of_clubs",
                    @"9_of_clubs",
                    @"10_of_clubs",
                    @"jack_of_clubs",
                    @"queen_of_clubs",
                    @"king_of_clubs",
                    @"ace_of_clubs",
                    nil], @"clubs",
                    [[NSArray alloc] initWithObjects:
                     @"1_of_hearts",
                     @"2_of_hearts",
                     @"3_of_hearts",
                     @"4_of_hearts",
                     @"5_of_hearts",
                     @"6_of_hearts",
                     @"7_of_hearts",
                     @"8_of_hearts",
                     @"9_of_hearts",
                     @"10_of_hearts",
                     @"jack_of_hearts",
                     @"queen_of_hearts",
                     @"king_of_hearts",
                     @"ace_of_hearts",
                     nil], @"hearts",
                    [[NSArray alloc] initWithObjects:
                     @"1_of_spades",
                     @"2_of_spades",
                     @"3_of_spades",
                     @"4_of_spades",
                     @"5_of_spades",
                     @"6_of_spades",
                     @"7_of_spades",
                     @"8_of_spades",
                     @"9_of_spades",
                     @"10_of_spades",
                     @"jack_of_spades",
                     @"queen_of_spades",
                     @"king_of_spades",
                     @"ace_of_spades",
                     nil], @"spades",
                    [[NSArray alloc] initWithObjects:
                     @"black_joker",
                     @"red_joker",
                     nil], @"jokers",
         nil];
    }
    return _cardNames;
}
@end
