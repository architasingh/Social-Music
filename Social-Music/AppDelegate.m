//
//  AppDelegate.m
//  Social-Music
//
//  Created by Archita Singh on 7/3/22.
//

#import "AppDelegate.h"
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemotePlayerAPI.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTSession.h>
#import <SpotifyiOS/SpotifyAppRemote.h>

@interface AppDelegate () <SPTSessionManagerDelegate, SPTAppRemotePlayerStateDelegate, SPTAppRemoteDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSString *spotifyClientID = [dict objectForKey: @"client_key"];
    NSString *spotifyClientIDSecret = [dict objectForKey: @"client_secret"];
    
    NSURL *spotifyRedirectURL = [NSURL URLWithString:@"spotify-ios-quick-start://spotify-login-callback"];
    
    self.configuration = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];
    
    self.configuration = [[SPTConfiguration alloc] initWithClientID:spotifyClientIDSecret redirectURL:spotifyRedirectURL];

    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];
   
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
    
    self.appRemote.delegate = self;
    
    self.configuration.playURI = @"spotify:track:20I6sIOMTCkB6w7ryavxtO";

    SPTScope requestedScope = SPTAppRemoteControlScope;
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    
    return self;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)sessionManager:(nonnull SPTSessionManager *)manager didInitiateSession:(nonnull SPTSession *)session {
    self.appRemote.connectionParameters.accessToken = session.accessToken;
    [self.appRemote connect];
    NSLog(@"success: %@", session);

}

- (void)sessionManager:(nonnull SPTSessionManager *)manager didFailWithError:(nonnull NSError *)error {
    NSLog(@"fail: %@", error);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
  NSLog(@"renewed: %@", session);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self.sessionManager application:app openURL:url options:options];
    return true;
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)appRemote {
    self.appRemote.playerAPI.delegate = self;
     [self.appRemote.playerAPI subscribeToPlayerState:^(id _Nullable result, NSError * _Nullable error) {
       if (error) {
         NSLog(@"error: %@", error.localizedDescription);
       }
     }];
    NSLog(@"connected");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"disconnected");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"failed");
}

- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    NSLog(@"Track name: %@", playerState.track.name);
    NSLog(@"player state changed");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  if (self.appRemote.isConnected) {
    [self.appRemote disconnect];
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  if (self.appRemote.connectionParameters.accessToken) {
    [self.appRemote connect];
  }
}

@end
