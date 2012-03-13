//
//  Card.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/9/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property (strong,nonatomic) NSString *suite;
@property (nonatomic) int faceValue;
@property (nonatomic) int gameValue;
@property (strong,nonatomic) NSString *color;
@property (strong,nonatomic) NSString *cardName;

-(Card *)initWithCardName: (NSString *) cardName;
@end
