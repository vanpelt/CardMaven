//
//  GameOfCards.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandOfCards.h"

@interface GameOfCards : NSObject
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *hands;

- (void)shuffle;
- (void)deal:(NSArray *) owners;
@end
