//
//  CardView.h
//  CardMaven
//
//  Created by Chris Van Pelt on 3/8/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIImageView
@property (weak, nonatomic) NSString * cardName;
- (CardView *)initWithImageAndCardName:(UIImage *)image cardName:(NSString *) cardName;
@end
