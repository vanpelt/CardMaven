//
//  GameStatusViewController.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/6/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface GameStatusViewController : UIViewController
@property (strong, nonatomic) NSMutableDictionary *cardsOnTable;
@property (weak, nonatomic) IBOutlet UIScrollView *statusScrollView;

- (void)setCardsForPlayer: (NSString *) playerName cardNames:(NSArray *) cardNames;

- (void)update: (NSArray *) data;
@end
