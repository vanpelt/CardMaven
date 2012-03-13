//
//  HandOfCards.h
//  CardMaven
//
//  Created by Chris Van Pelt on 2/25/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "GameViewController.h"
#import "CardView.h"

@interface HandOfCardsViewController : UIViewController <UIGestureRecognizerDelegate>
{
    NSData *_templateCardClone;
}
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic, strong) NSMutableArray *cardRotations;
@property (nonatomic, strong) UIView *selectedCard;
@property (weak, nonatomic) IBOutlet CardView *templateCard;

//-(NSMutableArray *) drawCards;
//-(void) transform: (float) rotation;
-(GameOfCards *)cardGame;
-(NSArray *) drawCards;
@end
