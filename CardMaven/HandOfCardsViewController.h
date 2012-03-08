//
//  HandOfCards.h
//  CardMaven
//
//  Created by Chris Van Pelt on 2/25/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "GameOfCards.h"

@interface HandOfCardsViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *cardNames;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic, strong) NSMutableArray *cardRotations;
@property (nonatomic, strong) GameOfCards *cardGame;
@property (nonatomic, strong) UIView *selectedCard;

-(NSMutableArray *) drawCards;
-(void) transform: (float) rotation;
@end
