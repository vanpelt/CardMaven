//
//  CardView.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/8/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "CardView.h"

@implementation CardView
@synthesize cardName = _cardName;
@synthesize legalMove = _legalMove;
@synthesize mask = _mask;
@synthesize card = _card;

-(UIView *)mask
{
    if (!_mask)
        _mask = [self.subviews objectAtIndex:1];
    return _mask;
}

-(UIImageView *)card
{
    if (!_card)
        _card = [self.subviews objectAtIndex:0];
    return _card;
}

- (void)setLegalMove:(BOOL)legalMove
{
    if (legalMove) {
        self.mask.alpha = 0.0;
    } else {
        self.mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        self.mask.backgroundColor = [UIColor blackColor];
        self.mask.alpha = 0.2;
        [self addSubview:self.mask];
    }
    _legalMove = legalMove;
}

- (id)initWithImageAndCardName:(UIImage *)image cardName:(NSString *) cardName
{
    UIImageView *card = [[UIImageView alloc] initWithImage:image];
    self = [super initWithFrame:card.frame];
    if (self) {
        [self addSubview:card];
        self.cardName = cardName;
    }
    return self; 
}

@end
