//
//  HomeViewController.h
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SPTSessionManager.h>
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemotePlayerAPI.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTSession.h>
#import <SpotifyiOS/SpotifyAppRemote.h>
#import <SpotifyiOS/SPTAppRemotePlayerState.h>


NS_ASSUME_NONNULL_BEGIN

@interface SongViewController : UIViewController 

@property (nonatomic, strong) SPTAppRemote *appRemote;

- (IBAction)didTapSpotify:(id)sender;
- (IBAction)didTapSkip:(id)sender;

@end

NS_ASSUME_NONNULL_END
