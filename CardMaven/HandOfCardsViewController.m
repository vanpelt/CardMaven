//
//  HandOfCards.m
//  CardMaven
//
//  Created by Chris Van Pelt on 2/25/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "HandOfCardsViewController.h"
#import "CardMavenAppDelegate.h"

@interface HandOfCardsViewController ()
@property (nonatomic) float rotation;
@end

@implementation HandOfCardsViewController
@synthesize cardViews = _cardViews;
@synthesize cardRotations = _cardRotations;
@synthesize selectedCard = _selectedCard;
@synthesize rotation = _rotation;
@synthesize templateCard = _templateCard;

#define CARD_SPACING 0.045

-(GameOfCards *)cardGame
{
    return ((GameViewController *)self.parentViewController).cardGame;
}

//This feels dirty and wrong in so many ways, but let's me design the card in Storyboard
-(CardView *)templateCardClone
{
    if (!_templateCardClone)
        _templateCardClone = [NSKeyedArchiver archivedDataWithRootObject:self.templateCard];
    return (CardView *)[NSKeyedUnarchiver unarchiveObjectWithData:_templateCardClone];
}

-(NSMutableArray *)cardRotations
{
    if (!_cardRotations)
        _cardRotations = [[NSMutableArray alloc] init];
    return _cardRotations;
}

- (IBAction)cardChosen:(UIGestureRecognizer *)recognizer
{
    CardView *cardView = (CardView *)recognizer.view;
    if(!self.selectedCard && cardView.legalMove) {
        self.selectedCard = recognizer.view;
        [UIView animateWithDuration:0.1 animations:^{
            recognizer.view.layer.position = CGPointMake(285,480);
        }];
    } else if (self.selectedCard == cardView) {
        self.selectedCard = nil;
        [self.cardGame playCardForPlayer:[[Card alloc] initWithCardName:cardView.cardName] player:self.cardGame.me];
        [[(GameViewController *)self.parentViewController gameStatus] draw];
        [UIView animateWithDuration:0.6 animations:^{
            recognizer.view.frame = CGRectMake(50, -800, 100, 300);
            recognizer.view.transform = CGAffineTransformMakeRotation(4);
        } completion:^(BOOL finished){
            [self drawCards];
        }];
        
        //Let everyone know
        NSArray *data = [[NSArray alloc] initWithObjects:cardView.cardName, nil];
        NSData* encodedArray = [NSKeyedArchiver archivedDataWithRootObject:data];
        [UIAppDelegate.connectionSession sendDataToAllPeers:encodedArray withDataMode:GKSendDataReliable error:nil];
        [(GameViewController *)self.parentViewController nextMove];
    }
}

- (IBAction)swipedDown:(UISwipeGestureRecognizer *) recognizer
{
    if (self.selectedCard == recognizer.view) {
        self.selectedCard = nil;
        [UIView animateWithDuration:0.1 animations:^{
            recognizer.view.layer.position = CGPointMake(285,530);
        }];
    }
}
- (IBAction)panned:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer velocityInView:self.view];
    
    self.rotation = translation.x / 10000.0;
    [self transform: self.rotation];
}

-(NSArray *) drawCards
{
    self.cardViews = [[NSMutableArray alloc] init];
    self.cardRotations = [[NSMutableArray alloc] init];
    for (UIView *card in [self.view subviews]) {
        [card removeFromSuperview];
    }
    float rotation = self.cardGame.me.hand.cards.count / 1.5 * -CARD_SPACING;
    for (int i = 0; i < self.cardGame.me.hand.cards.count; i++){
        Card *card = (Card *)[self.cardGame.me.hand.cards objectAtIndex:i];
        NSString *cardName = card.cardName;
        //NSString *fileName = [cardName stringByAppendingFormat:@".png"];
        CardView *template = [self templateCardClone];
        
        template.hidden = NO;
        template.card.image = [UIImage imageNamed:cardName];
        template.cardName = cardName;
        //CardView *view = [[CardView alloc] initWithImageAndCardName:[UIImage imageNamed:cardName] cardName:cardName];
        
        //view.bounds = CGRectMake(0,0,parentView.bounds.size.width, parentView.bounds.size.height);
        //view.frame = self.view.frame;
        template.layer.cornerRadius = 12    ;
        template.layer.masksToBounds = YES;
        template.layer.anchorPoint = CGPointMake(0.75,1.0);
        template.layer.position = CGPointMake(285,530);
        [self.view addSubview:template];
        template.legalMove = [[self cardGame] legalMoveForPlayer:card player:[self.cardGame me]];
        
        if (template.legalMove && rotation < 0.1)
            rotation += CARD_SPACING * 2.5;
        else 
            rotation += CARD_SPACING;
        [self.cardRotations addObject: [NSNumber numberWithFloat:rotation ]];
        //NSLog(@"Rotating %@ to %@", cardName, [self.cardRotations objectAtIndex:i]);
        template.transform = CGAffineTransformMakeRotation([[self.cardRotations objectAtIndex:i] floatValue]);
        template.userInteractionEnabled = true;
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedDown:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        swipeDown.delegate = self;
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cardChosen:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        swipeUp.delegate = self;
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardChosen:)];
        tapped.numberOfTapsRequired = 2;
        [template addGestureRecognizer:tapped];
        [template addGestureRecognizer:swipeUp];
        [template addGestureRecognizer:swipeDown];
        [self.cardViews addObject:template];
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
            //NSString *cardName = [self.hand.cards objectAtIndex:index];
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
           // NSString *cardName = [self.hand.cards objectAtIndex:index];
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

- (void)viewDidUnload {
    [self setTemplateCard:nil];
    [super viewDidUnload];
}
@end
