//
//  InfoViewController.m
//  CardMaven
//
//  Created by Chris Van Pelt on 3/7/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "InfoViewController.h"
#import "CardMavenAppDelegate.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (IBAction)newGame:(id)sender {
    [self cancel:sender];
    NSLog(@"Parent %@", [self presentingViewController]);
    [(UINavigationController *)self.presentingViewController popViewControllerAnimated:YES];
}
- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)connectToPeers:(id)sender {
    [UIAppDelegate.connectionPicker show];
}

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
