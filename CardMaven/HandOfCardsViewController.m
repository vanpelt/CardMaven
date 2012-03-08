//
//  HandOfCards.m
//  CardMaven
//
//  Created by Chris Van Pelt on 2/25/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "HandOfCardsViewController.h"
#import "CardMavenAppDelegate.h"
#import "CardView.h"

@interface HandOfCardsViewController ()
@property (nonatomic) float rotation;
@end

@implementation HandOfCardsViewController
@synthesize cardNames = _cardNames;
@synthesize cardViews = _cardViews;
@synthesize cardRotations = _cardRotations;
@synthesize selectedCard = _selectedCard;
@synthesize rotation = _rotation;
@synthesize cardGame = _cardGame;

#define CARD_SPACING 0.03

-(NSMutableArray *)cardViews
{
    if (!_cardViews)
        _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

-(NSMutableArray *)cardRotations
{
    if (!_cardRotations)
        _cardRotations = [[NSMutableArray alloc] init];
    return _cardRotations;
}

-(GameOfCards *) cardGame
{
    if(!_cardGame)
        _cardGame = [[GameOfCards alloc] init];
    return _cardGame;
}

- (IBAction)swipedUp:(UISwipeGestureRecognizer *)recognizer
{
    if(!self.selectedCard) {
        self.selectedCard = recognizer.view;
        recognizer.view.layer.position = CGPointMake(285,480);
    } else if (self.selectedCard == recognizer.view) {
        NSArray *data = [[NSArray alloc] initWithObjects:((CardView *)recognizer.view).cardName, nil];
        NSData* encodedArray = [NSKeyedArchiver archivedDataWithRootObject:data];
        [UIAppDelegate.connectionSession sendDataToAllPeers:encodedArray withDataMode:GKSendDataReliable error:nil];
    }
}

- (IBAction)swipedDown:(UISwipeGestureRecognizer *) recognizer
{
    if (self.selectedCard == recognizer.view) {
        self.selectedCard = nil;
        recognizer.view.layer.position = CGPointMake(285,530);
    }
}
- (IBAction)panned:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer velocityInView:self.view];
    
    self.rotation = translation.x / 10000.0;
    [self transform: self.rotation];
}

-(NSArray *) drawCards
{
    float rotation = -0.2;
    for (int i = 0; i < self.cardNames.count; i++){
        NSString *cardName = [self.cardNames objectAtIndex:i];
        rotation += CARD_SPACING;
        [self.cardRotations addObject: [NSNumber numberWithFloat:rotation ]];
        //NSString *fileName = [cardName stringByAppendingFormat:@".png"];
        CardView *view = [[CardView alloc] initWithImageAndCardName:[UIImage imageNamed:cardName] cardName:cardName];
        //view.bounds = CGRectMake(0,0,parentView.bounds.size.width, parentView.bounds.size.height);
        view.frame = self.view.frame;
        view.layer.anchorPoint = CGPointMake(0.75,1.0);
        view.layer.position = CGPointMake(285,530);
        [self.view addSubview:view];
        //NSLog(@"Rotating %@ to %@", cardName, [self.cardRotations objectAtIndex:i]);
        view.transform = CGAffineTransformMakeRotation([[self.cardRotations objectAtIndex:i] floatValue]);
        view.userInteractionEnabled = true;
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedDown:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        swipeDown.delegate = self;
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        swipeUp.delegate = self;
        [view addGestureRecognizer:swipeUp];
        [view addGestureRecognizer:swipeDown];
        [self.cardViews addObject:view];
    }
    return self.cardViews;
}
//Refactor this monstrosity
-(void) transform: (float) factor
{
    BOOL lastMaxed = NO;
    BOOL firstMaxed = NO;
    int index;
    if (factor > 0) lastMaxed = YES;
    else firstMaxed = YES;
    for (int i = 0; i < self.cardViews.count; i++) {
        if (lastMaxed) {
            index = self.cardViews.count - 1 - i;
            //NSString *cardName = [self.cardNames objectAtIndex:index];
            UIView *cardView = [self.cardViews objectAtIndex:index];
            float rotation = [[self.cardRotations objectAtIndex:index] floatValue];
            float maxed;
            float max = 0.5 - (i * CARD_SPACING);
            if(rotation + factor >= max) {
                lastMaxed = YES;
                maxed = max;
            } else if(index > 0) {
                float prev = [[self.cardRotations objectAtIndex: index - 1] floatValue];
                if (rotation - prev > 0.14) {
                    lastMaxed = YES;
                } else {
                    lastMaxed = NO;
                }
                maxed = rotation + factor;
            } else {
                lastMaxed = NO;
                maxed = rotation + factor;
            }
            cardView.transform = CGAffineTransformMakeRotation(maxed);
            
            [self.cardRotations replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:maxed ]];
        } else if (firstMaxed) {
            index = i;
           // NSString *cardName = [self.cardNames objectAtIndex:index];
            UIView *cardView = [self.cardViews objectAtIndex:index];
            float rotation = [[self.cardRotations objectAtIndex:index] floatValue];
            float maxed;
            float max = -0.2 + (i * CARD_SPACING);
            if(rotation + factor <= max) {
                firstMaxed = YES;
                maxed = max;
            } else {
                firstMaxed = NO;
                maxed = rotation + factor;
            }
            cardView.transform = CGAffineTransformMakeRotation(maxed);
            
            [self.cardRotations replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:maxed ]];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];        
    [self.cardGame shuffle];
    [self.cardGame deal: [[NSArray alloc] initWithObjects: @"cvp", nil ]];
    NSLog(@"Hands: %@", self.cardGame.hands);
    self.cardNames = ((HandOfCards*)[self.cardGame.hands objectAtIndex:0]).cards;
    
    [self drawCards];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)]];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
