//
//  AppDelegate.h
//  Social-Music
//
//  Created by Archita Singh on 7/3/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SPTSessionManager.h>
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemotePlayerAPI.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTSession.h>
#import <SpotifyiOS/SpotifyAppRemote.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTAppRemoteDelegate, SPTSessionManagerDelegate>

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) SPTAppRemote *appRemote;

@property (nonatomic, weak) id<SPTAppRemotePlayerStateDelegate> delegate;

@end

