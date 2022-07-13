//
//  HomeViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "SongViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemotePlayerAPI.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTSession.h>
#import <SpotifyiOS/SpotifyAppRemote.h>

@interface SongViewController () <SPTSessionManagerDelegate, SPTAppRemotePlayerStateDelegate, SPTAppRemoteDelegate>

@end

@implementation SongViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapSkip:(id)sender {
    
    [self.appRemote.playerAPI skipToNext:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"failed");
        } else {
            NSLog(@"success");
        }
    }];
    
}

- (IBAction)didTapSpotify:(id)sender {
    /*NSLog(@"reached");
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        
    NSString *spotifyClientID = [dict objectForKey: @"client_key"];
    NSURL *spotifyRedirectURL = [NSURL URLWithString:@"com.codepath.Social-Music://spotify-login-callback"];
        
    self.configuration = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];

    self.configuration.playURI = @"";
    
    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];
       
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
        
    self.appRemote.delegate = self;
    NSLog(@"redirected");
    NSLog(@"%@", self.configuration.playURI);
    
    SPTScope requestedScope = SPTAppRemoteControlScope|SPTUserTopReadScope;
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    
    [self.spotifyButton setHidden:YES];
    
    if (self.appRemote.connectionParameters.accessToken) {
      [self.appRemote connect];
    }*/

}

/*- (void)sessionManager:(nonnull SPTSessionManager *)manager didInitiateSession:(nonnull SPTSession *)session {
    self.appRemote.connectionParameters.accessToken = session.accessToken; // update api manager with token
    NSLog(@"Token: %@", session.accessToken);
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
}*/

@end
