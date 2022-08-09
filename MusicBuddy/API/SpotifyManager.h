//
//  APIManager.h
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
#import <SpotifyiOS/SPTAppRemotePlayerState.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyManager : NSObject <SPTAppRemoteDelegate, SPTSessionManagerDelegate>

+ (id)shared;
- (void)authenticateSpotify;
- (void)applicationWillResignActive;
- (void)applicationDidBecomeActive;
- (void)setupSpotify;

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) SPTAppRemote *appRemote;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, weak) id<SPTAppRemotePlayerStateDelegate> delegate;
@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) UIImage *trackImage;

@end

NS_ASSUME_NONNULL_END
