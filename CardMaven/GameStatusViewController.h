//
//  GameStatusViewController.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/6/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "GameViewController.h"

@interface GameStatusViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *statusScrollView;

- (void)draw;

- (void)update: (NSArray *) data;
-(GameOfCards *)cardGame;
@end
