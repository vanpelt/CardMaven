//
//  CardMavenAppDelegate.h
//  CardMaven
//
//  Created by Chris Van Pelt on 2/24/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameViewController.h"

#define UIAppDelegate ((CardMavenAppDelegate *)[UIApplication sharedApplication].delegate)
@interface CardMavenAppDelegate : UIResponder <UIApplicationDelegate, GKSessionDelegate, GKPeerPickerControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *connectionPeers;
@property (strong, nonatomic) GKPeerPickerController *connectionPicker;
@property (strong) GKSession *connectionSession;
@property (weak, nonatomic) GameViewController *gameController;

@end
