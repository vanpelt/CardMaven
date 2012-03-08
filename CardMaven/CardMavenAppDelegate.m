//
//  CardMavenAppDelegate.m
//  CardMaven
//
//  Created by Chris Van Pelt on 2/24/12.
//  Copyright (c) 2012 CrowdFlower. All rights reserved.
//

#import "CardMavenAppDelegate.h"
#import "GameStatusViewController.h"

@interface CardMavenAppDelegate ()
@property (weak, nonatomic) GameStatusViewController *gameStatus;
@end

@implementation CardMavenAppDelegate

@synthesize window = _window;
@synthesize connectionPeers = _connectionPeers;
@synthesize connectionPicker = _connectionPicker;
@synthesize connectionSession = _connectionSession;
@synthesize gameStatus = _gameStatus;

- (GameStatusViewController *)gameStatus
{
    if (!_gameStatus) {
        _gameStatus = [[self.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"game_status"];
    }
    return _gameStatus;
}

- (GKPeerPickerController *)connectionPicker
{
    if(!_connectionPicker) {
        _connectionPicker = [[GKPeerPickerController alloc] init];
        _connectionPicker.delegate = self;
        _connectionPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    }
    return _connectionPicker;
}

- (NSMutableArray *)connectionPeers
{
    if(!_connectionPeers)
        _connectionPeers = [[NSMutableArray alloc] init];
    return _connectionPeers;
}

#pragma mark - GKPeerPickerControllerDelegate
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    // Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
    GKSession* session = [[GKSession alloc] initWithSessionID:@"com.cards.connect" displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

// Tells us that the peer was connected
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    // Get the session and assign it locally
    self.connectionSession = session;
    session.delegate = self;
    
    [picker dismiss];
}

#pragma mark - GKSessionDelegate
// Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSArray *receivedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //Handle the data received in the array
    [self.gameStatus update:receivedData];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    if (state == GKPeerStateConnected) {
        // Add the peer to the Array
        [self.connectionPeers addObject:peerID];
        
        // Used to acknowledge that we will be sending data
        [session setDataReceiveHandler:self withContext:nil];
        
        //In case you need to do something else when a peer connects, do it here
    }
    else if (state == GKPeerStateDisconnected) {
        [self.connectionPeers removeObject:peerID];
        //Any processing when a peer disconnects
    }
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
