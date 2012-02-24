//
//  CardMavenViewController.m
//  CardMaven
//
//  Created by Chris Van Pelt on 2/24/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "CardMavenViewController.h"

@interface CardMavenViewController ()

@end

@implementation CardMavenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
