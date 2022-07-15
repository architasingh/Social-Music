//
//  APIManager.m
//  Social-Music
//
//  Created by Archita Singh on 7/12/22.
//

#import <Foundation/Foundation.h>
#import <SpotifyiOS/SPTSessionManager.h>
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemotePlayerAPI.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTSession.h>
#import <SpotifyiOS/SpotifyAppRemote.h>
#import "SpotifyManager.h"

@implementation SpotifyManager
+ (id)shared {
    static SpotifyManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)setupSpotify {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        
    NSString *spotifyClientID = [dict objectForKey: @"client_key"];
    NSURL *spotifyRedirectURL = [NSURL URLWithString:@"com.codepath.Social-Music://spotify-login-callback"];

    self.configuration = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];

    self.configuration.playURI = @"";

    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];

    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];

    self.appRemote.delegate = self;

}

- (void)authenticateSpotify {
    SPTScope requestedScope = SPTAppRemoteControlScope|SPTUserTopReadScope;
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
}

- (void)applicationDidBecomeActive {
    if (self.appRemote.connectionParameters.accessToken) {
      [self.appRemote connect];
    }
}

- (void)applicationWillResignActive {
    if (self.appRemote.isConnected) {
      [self.appRemote disconnect];
    }
}

// Spotify Delegate Functions

- (void)sessionManager:(nonnull SPTSessionManager *)manager didInitiateSession:(nonnull SPTSession *)session {
    self.appRemote.connectionParameters.accessToken = session.accessToken; // update api manager with token
    NSLog(@"Token: %@", session.accessToken);
    [self.appRemote connect];
    [[NSUserDefaults standardUserDefaults] setObject:session.accessToken forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"success: %@", session);
}

- (void)sessionManager:(nonnull SPTSessionManager *)manager didFailWithError:(nonnull NSError *)error {
    NSLog(@"fail: %@", error);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
  NSLog(@"renewed: %@", session);
}

- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    NSLog(@"Track name: %@", playerState.track.name);
    NSLog(@"player state changed");
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


@end

