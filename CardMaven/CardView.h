//
//  CardView.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/8/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView
@property (weak, nonatomic) NSString * cardName;
@property (nonatomic) BOOL legalMove;
@property (weak, nonatomic) UIView *mask;
@property (weak, nonatomic) UIImageView *card;


- (CardView *)initWithImageAndCardName:(UIImage *)image cardName:(NSString *) cardName;
@end
