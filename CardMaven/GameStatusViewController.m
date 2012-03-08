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
@synthesize cardsOnTable = _cardsOnTable;

- (NSMutableDictionary *) cardsOnTable {
    if (!_cardsOnTable)
        _cardsOnTable = [NSMutableDictionary dictionary];
    return _cardsOnTable;
}

- (void)setCardsForPlayer: (NSString *) playerName cardNames:(NSArray *) cardNames
{
    [self.cardsOnTable setValue:cardNames forKey: playerName];
    for (NSString *cardName in cardNames) {
        UIImage *rawCard = [UIImage imageNamed:cardName];
        
        float width = rawCard.size.width / 5.75;
        CGRect rect = CGRectMake(7, 7, width, (rawCard.size.height / 4));
        CGImageRef imageRef = CGImageCreateWithImageInRect([rawCard CGImage], rect);
        UIImage *img = [UIImage imageWithCGImage:imageRef scale:2 orientation:UIImageOrientationUp];
        
        //ARC takes care of this I think...
        //CGImageRelease(imageRef);
        
        UIImageView *card = [[UIImageView alloc] initWithImage:img];
        float offset = 5 + ([self.cardsOnTable allValues].count - 1) * width;
        card.center = CGPointMake(card.center.x + offset, card.center.y + 5);
        card.layer.masksToBounds = YES;
        card.layer.cornerRadius = 5;
        [self.statusScrollView addSubview:card];
    }
}

- (void)update:(NSArray *)data
{
    NSLog(@"Whoa %@", data);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Whoa! %@", self.statusScrollView);
    self.statusScrollView.contentSize = CGSizeMake(3000, 100);
    [self setCardsForPlayer: @"cvp" cardNames: [[NSArray alloc] initWithObjects:@"ace_of_spades", nil]];
    [self setCardsForPlayer: @"bpo" cardNames: [[NSArray alloc] initWithObjects:@"2_of_diamonds", nil]];
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
