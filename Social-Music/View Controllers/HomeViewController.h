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


NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController <SPTSessionManagerDelegate, SPTAppRemotePlayerStateDelegate, SPTAppRemoteDelegate>

@property (nullable, nonatomic, strong, readonly) id<SPTAppRemoteUserAPI> userAPI;

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) SPTAppRemote *appRemote;

@property (weak, nonatomic) IBOutlet UIButton *spotifyButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
- (IBAction)didTapLogout:(id)sender;
- (IBAction)didTapSpotify:(id)sender;

@end

NS_ASSUME_NONNULL_END
