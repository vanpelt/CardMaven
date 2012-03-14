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


/* Animate the cards in status and start a new hand
 */
- (void)handFinished
{
    NSLog(@"hand finished called...");
    for (int i = 0; i < [self.statusScrollView subviews].count; i++) {
        UIView *player = [[self.statusScrollView subviews] objectAtIndex:i];
        [UIView animateWithDuration:0.4 delay: i / 8.0 options: 0 animations:^{
            player.transform = CGAffineTransformMakeRotation(RADIANS(15 + (10 * i)));
            player.frame = CGRectMake(400 + (i * 100), -100 - (i * 50), 70, 90);
        } completion:^(BOOL finished){
            if (finished && i == 2) {
                NSLog(@"New game bitches!");
                [self.cardGame newHand];
                [((GameViewController *)self.parentViewController) nextMove];
            }
        }];
    }
}

- (void)draw
{
    int i = 0;
    for (UIView *player in [self.statusScrollView subviews]) {
        [player removeFromSuperview];
    }
    for (PlayerOfCards *player in self.cardGame.players) {
        float width = 74;
        float height = 90;
        
        UIView *container = [[UIView alloc] initWithFrame: CGRectMake(i * (width+5) + 5, 5, width, height)];
        container.layer.masksToBounds = YES;
        container.layer.cornerRadius = 5;
        container.layer.borderWidth = 1;
        container.layer.borderColor = [[UIColor grayColor] CGColor];
        container.backgroundColor = [UIColor whiteColor];
        //container.alpha = 0.9;
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(5,78,width,10)];
        name.font = [UIFont systemFontOfSize:11];
        name.backgroundColor = [UIColor clearColor];
        name.text = [player displayName];
        
        [container addSubview:name];
        
        if ([player won]) {
            NSLog(@"HEY! %@ won!!!", player.name);
            //__block int times  = 0;
            container.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5));
            [UIView animateWithDuration:0.15 delay:0 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^{
                [UIView setAnimationRepeatCount:6.0];
                container.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5));
            } completion: ^(BOOL finished){
                if(finished) {
                    container.transform = CGAffineTransformIdentity;
                    [self handFinished];
                }
                    
                
            }];
        }
        
        for (Card *card in player.cardsInPlay) {
            CGRect rect = CGRectMake(0, 0, 104, 183);
            UIImage *rawCard = [UIImage imageNamed:card.cardName];
            
            CGImageRef imageRef = CGImageCreateWithImageInRect([rawCard CGImage], rect);
            
            CGImageRef maskRef = [[UIImage imageNamed:[NSString stringWithFormat: @"%@_card_mask", card.color]] CGImage];
            
            CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                                CGImageGetHeight(maskRef),
                                                CGImageGetBitsPerComponent(maskRef),
                                                CGImageGetBitsPerPixel(maskRef),
                                                CGImageGetBytesPerRow(maskRef),
                                                CGImageGetDataProvider(maskRef), NULL, false);
            
            CGImageRef maskedRef = CGImageCreateWithMask(imageRef, mask);
            UIImage *img = [UIImage imageWithCGImage:maskedRef scale:2.3 orientation:UIImageOrientationUp];
            //I wonder if ARC takes care of this?
            //CGImageRelease(imageRef);
            //CGImageRelease(maskedRef);
            
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
