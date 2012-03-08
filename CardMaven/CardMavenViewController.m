//
//  CardMavenViewController.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/6/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "CardMavenViewController.h"
#import "GameStatusViewController.h"

@interface CardMavenViewController ()
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation CardMavenViewController
@synthesize infoButton = _infoButton;
@synthesize game = _game;

- (IBAction)newGame:(id)sender {
    [self cancel:sender];
    NSLog(@"Parent %@", [self presentingViewController]);
    [self.navigationController popViewControllerAnimated:YES];
    //[self.parentViewController.navigationController pushViewController:[[self storyboard] instantiateViewControllerWithIdentifier: @"new_game"] animated:YES];
}
- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Loading the maven");
    UIViewController *hand_of_cards = [[self storyboard] instantiateViewControllerWithIdentifier:@"hand_of_cards"];
    [self addChildViewController:hand_of_cards];
    [self.view addSubview:hand_of_cards.view];
    
    GameStatusViewController *game_status = [[self storyboard] instantiateViewControllerWithIdentifier: @"game_status"];
    [self addChildViewController:game_status];
    game_status.view.center = CGPointMake(160,620);
    [self.view addSubview:game_status.view];
    [self.view bringSubviewToFront:self.infoButton];
}

- (void)viewDidUnload
{
    [self setInfoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
