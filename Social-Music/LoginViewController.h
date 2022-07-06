//
//  HomeViewController.h
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SPTSessionManager.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemotePlayerAPI.h>
#import <SpotifyiOS/SPTSession.h>
#import <SpotifyiOS/SPTAppRemotePlayerState.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController <SPTSessionManagerDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;

@end

NS_ASSUME_NONNULL_END
