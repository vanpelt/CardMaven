//
//  Card.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/9/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "Card.h"

@implementation Card
@synthesize suite = _suite;
@synthesize faceValue = _faceValue;
@synthesize gameValue = _gameValue;
@synthesize color = _color;
@synthesize cardName = _cardName;

-(void)setSuite:(NSString *)suite
{
    if ([suite isEqualToString:@"hearts"] || [suite isEqualToString:@"diamonds"])
        self.color = @"red";
    else
        self.color = @"black";
    _suite = suite;
}

-(NSNumber *)sortValue
{
    int suiteMultiplier;
    if([self.suite isEqualToString:@"clubs"])
        suiteMultiplier = 1;
    else if([self.suite isEqualToString:@"diamonds"])
        suiteMultiplier = 2;
    else if([self.suite isEqualToString:@"hearts"])
        suiteMultiplier = 3;
    else
        suiteMultiplier = 4;
    
    return [NSNumber numberWithInt:self.faceValue + (14 * suiteMultiplier)];
}

-(Card *)initWithCardName: (NSString *) cardName
{
    NSArray *components = [cardName componentsSeparatedByString:@"_"];
    if ([[components objectAtIndex:0]intValue] > 0) {
        self.faceValue = [[components objectAtIndex:0]intValue];
        self.suite = [components objectAtIndex:2];
    } else if ([cardName hasSuffix:@"joker"]) {
        self.faceValue = 0;
        self.color = [components objectAtIndex:0];
    } else {
        self.suite = [components objectAtIndex:2];
        if ([[components objectAtIndex:0] isEqualToString:@"jack"])
            self.faceValue = 11;
        else if([[components objectAtIndex:0] isEqualToString:@"queen"])
            self.faceValue = 12;
        else if([[components objectAtIndex:0] isEqualToString:@"king"])
            self.faceValue = 13;
        else if([[components objectAtIndex:0] isEqualToString:@"ace"])
            self.faceValue = 14;

    }
    self.gameValue = self.faceValue;
    self.cardName = cardName;
    return self;
}

- (NSComparisonResult)compare: (Card *) against
{
    return [[self sortValue] compare: [against sortValue]];
}

- (BOOL) isEqual:(Card *)object
{
    return [self.cardName isEqualToString:object.cardName];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<Card: %@>",self.cardName];
}

@end
