//
//  HandOfCards.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandOfCards : NSObject
@property (strong, nonatomic) NSMutableArray* cards;
@property (strong, nonatomic) NSString* owner;

-(HandOfCards *)initWithOwnerAndCards: (NSString *)owner cards:(NSMutableArray *)cards;
@end
