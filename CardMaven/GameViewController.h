//
//  GameViewController.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/6/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameOfCards.h"
#import "GameStatusViewController.h"
#import "HandOfCardsViewController.h"
@class HandOfCardsViewController;
@class GameStatusViewController;
@interface GameViewController : UIViewController
@property (strong, nonatomic) GameOfCards *cardGame;
@property (weak, nonatomic) GameStatusViewController *gameStatus;
@property (weak, nonatomic) HandOfCardsViewController *handOfCards;
-(void)nextMove;
@end
