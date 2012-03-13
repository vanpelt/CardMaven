//
//  GameOfCards.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "GameOfCards.h"
#import "time.h"

@interface GameOfCards ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, readonly) NSDictionary *cardNames;
@end

@implementation GameOfCards
@synthesize cards = _cards;
@synthesize cardNames = _cardNames;
@synthesize hands = _hands;
@synthesize cardsPerHand = _cardsPerHand;
@synthesize cardsPlayed =_cardsPlayed;
@synthesize currentPlayer = _currentPlayer;
@synthesize cardsInPlay = _cardsInPlay;
@synthesize players = _players;
@synthesize startOfHand = _startOfHand;

- (GameOfCards *)init
{
    self = [super init];
    if(self)
        self.startOfHand = YES;
    return self;
}

- (NSMutableArray *)players
{
    if (!_players)
        _players = [[NSMutableArray alloc] init];
    return _players;
}

- (NSMutableArray *)cardsInPlay
{
    if (!_cardsInPlay)
        _cardsInPlay = [[NSMutableArray alloc] init];
    return _cardsInPlay;
}

- (Card *)lastCardPlayed
{
    return [self.cardsInPlay lastObject];
}

- (Card *)cardLead
{
    if (self.cardsInPlay.count > 0)
        return [self.cardsInPlay objectAtIndex:0];
    else
        return NULL; 
}

- (void)deal
{
    self.hands = [[NSMutableArray alloc] initWithCapacity:self.players.count];
    for (PlayerOfCards *player in self.players) {
        player.hand = [[HandOfCards alloc] initWithPlayerAndCards:player cards:[self drawCardsForPlayer:self.cardsPerHand]];
        [self.hands addObject:player.hand];
    }
}

- (void)shuffle
{
    self.cards = [self shuffleCards:self.cards];
}

- (NSMutableArray *)shuffleCards: (NSMutableArray *)cards
{
    srand( time(NULL) );
    NSMutableArray *shuffledCards = [[NSMutableArray alloc] initWithCapacity:cards.count];
    NSMutableArray *originalCards = [cards mutableCopy];
    int randomIndex;
    for( int index = 0; index < cards.count; index++) {
        randomIndex = rand() % originalCards.count;
        [shuffledCards addObject:[originalCards objectAtIndex:randomIndex]];
        [originalCards removeObjectAtIndex:randomIndex];
    }
    return shuffledCards;
}

- (void)addPlayer:(PlayerOfCards *)player
{
    [self.players addObject:player];
}

-(void)findNextPlayer
{
    if (self.handComplete) {
        self.currentPlayer = [self winner];
    } else {
        int i = [self.players indexOfObject:self.currentPlayer];
        if (i == self.players.count - 1)
            i = 0;
        else 
            i += 1;
        self.currentPlayer = [self.players objectAtIndex:i];
    }
}

-(PlayerOfCards *)winner
{
    return nil;
}

-(NSNumber *)scoreOfCardInPlay: (Card *) card
{
    return [NSNumber numberWithInt:1];
}

-(int)pointValue:(Card *)card
{
    return 0;
}

-(BOOL)playCardForPlayer: (Card *)card player:(PlayerOfCards *) player
{
    self.cardsPlayed += 1;
    self.startOfHand = false;
    NSLog(@"Played %@ for %@", card.cardName, player.name);
    [player.hand play:card.cardName];
    [self.cardsInPlay addObject:card];
    [self findNextPlayer];
    return YES;
}

-(Card *)playRandomCardForPlayer: (PlayerOfCards *) player
{
    Card *rand = [player.hand.cards objectAtIndex:0];
    [self playCardForPlayer:rand player:player];
    return rand;
}

- (HandOfCards *)myHand
{
    return [self me].hand;
}

- (PlayerOfCards *)me
{
    return [self.players objectAtIndex:0];
}

- (BOOL)legalMoveForPlayer:(Card *)card player:(PlayerOfCards *) player
{
    return YES;
}

- (BOOL)handComplete
{
    return NO;
}

- (void)newHand
{
    self.startOfHand = YES;
    for (PlayerOfCards *player in self.players) {
        player.cardsInPlay = nil;
    }
    self.cardsInPlay = nil;
}

- (NSMutableArray *)drawCardsForPlayer: (int) howMany
{
    NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity:howMany];
    for (int i = 0; i < howMany; i++) {
        //This could come back to bite...
        Card *card = [[Card alloc] initWithCardName:[self.cards objectAtIndex:self.cards.count -1]];
        [cards addObject:card];
        [self.cards removeLastObject];
    }
    return cards;
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
