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

- (id)initWithImageAndCardName:(UIImage *)image cardName:(NSString *) cardName
{
    self = [super initWithImage:image];
    if (self) {
        self.cardName = cardName;
    }
    return self;
}

@end
