//
//  NewGameViewController.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "NewGameViewController.h"
#import "GameViewController.h"
#import "HeartsGame.h"
#import "CardMavenAppDelegate.h"

@interface NewGameViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *gamesScrollView;
@end

@implementation NewGameViewController
@synthesize gamesScrollView = _gamesScrollView;
@synthesize availableGames = _availableGames;

- (NSDictionary*)availableGames
{
    //In the future we'll pull this from NSUserDefaults
    if(!_availableGames)
        _availableGames = [[NSDictionary alloc] initWithObjectsAndKeys: [HeartsGame class], @"Hearts", nil];
    return _availableGames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    //self.navigationController.navigationBar.translucent = YES;
    self.wantsFullScreenLayout = YES;
    //A rather hacky way to get rid of navlayouts blue bar.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //self.view.bounds.origin = CGPointMake(0,0);
    UIImage *buttonImage = [[UIImage imageNamed:@"blackButton"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    self.gamesScrollView.contentSize = self.view.frame.size;
    for (NSString *game in [self.availableGames allKeys]) {
        UIButton * gameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [gameButton setTitle:game forState:UIControlStateNormal];
        [gameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        gameButton.titleLabel.shadowColor = [UIColor darkGrayColor];
        gameButton.titleLabel.shadowOffset = CGSizeMake(0,-1);
        gameButton.titleLabel.font = [UIFont fontWithName: @"Futura Medium" size:16];
        // Set the background for any states you plan to use
        [gameButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [gameButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
        gameButton.frame = CGRectMake(80.0, 30.0, 160.0, 40.0);
        [gameButton addTarget:self action:@selector(transitionToGame:) forControlEvents:UIControlEventTouchDown];
        [self.gamesScrollView addSubview:gameButton];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{
    if ([segue.identifier isEqualToString:@"game_chosen"]) {
        [segue.destinationViewController setCardGame:[self gameFromString: sender.titleLabel.text ]];
        UIAppDelegate.gameController = segue.destinationViewController;
    }
}

- (GameOfCards *)gameFromString: (NSString *)title
{
    return [[[self.availableGames objectForKey:title] alloc] init];
}

- (IBAction)transitionToGame:(id)sender
{
    [self performSegueWithIdentifier:@"game_chosen" sender:sender];
}

- (void)viewDidUnload
{
    [self setGamesScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
