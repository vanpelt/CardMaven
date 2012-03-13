//
//  GameStatusViewController.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/6/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "GameStatusViewController.h"

@interface GameStatusViewController ()
@end

@implementation GameStatusViewController
@synthesize statusScrollView = _statusScrollView;
static inline double RADIANS (double degrees) {return degrees * M_PI/180;}

-(GameOfCards *)cardGame
{
    return ((GameViewController *)self.parentViewController).cardGame;
}

- (void)draw
{
    int i = 0;
    for (UIView *player in [self.statusScrollView subviews]) {
        [player removeFromSuperview];
    }
    for (PlayerOfCards *player in self.cardGame.players) {
        float width = 60;
        float height = 90;
        
        UIView *container = [[UIView alloc] initWithFrame: CGRectMake(5 + i * 75, 5, 70, height)];
        container.layer.masksToBounds = YES;
        container.layer.cornerRadius = 5;
        container.layer.borderWidth = 1;
        container.layer.borderColor = [[UIColor grayColor] CGColor];
        container.backgroundColor = [UIColor whiteColor];
        container.alpha = 0.9;
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(5,80,70,10)];
        name.font = [UIFont systemFontOfSize:11];
        name.backgroundColor = [UIColor clearColor];
        name.text = [player displayName];
        
        [container addSubview:name];
        
        if ([player won]) {
            NSLog(@"HEY! %@ won!!!", player.name);
            //__block int times  = 0;
            container.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5));
            [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^{
                [UIView setAnimationRepeatCount:5.0];
                container.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5));
            } completion: ^(BOOL finished){
                if(finished) {
                    //container.transform = CGAffineTransformIdentity;
                    [self.cardGame newHand];
                    [((GameViewController *)self.parentViewController) nextMove];
                }
                
            }];
        }
        
        for (Card *card in player.cardsInPlay) {
            CGRect rect = CGRectMake(7, 7, width * 1.5, height * 2);
            UIImage *rawCard = [UIImage imageNamed:card.cardName];
            CGImageRef imageRef = CGImageCreateWithImageInRect([rawCard CGImage], rect);
            UIImage *img = [UIImage imageWithCGImage:imageRef scale:2.3 orientation:UIImageOrientationUp];
            //ARC takes care of this I think...
            //CGImageRelease(imageRef);
            
            UIImageView *card = [[UIImageView alloc] initWithImage:img];
            //float offset = 5 + i * width;
            card.center = CGPointMake(card.center.x + 15, card.center.y + 1);
            [container addSubview:card];
        }
        i += 1;
        [self.statusScrollView addSubview:container];
    }
}

- (void)update:(NSArray *)data
{
    NSLog(@"Whoa %@", data);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusScrollView.contentSize = CGSizeMake(3000, 100);
    [self draw];
}

- (void)viewDidUnload
{
    [self setStatusScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
