//
//  HomeViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "TrackViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemotePlayerAPI.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTSession.h>
#import <SpotifyiOS/SpotifyAppRemote.h>
#import "SpotifyManager.h"

@interface TrackViewController ()

@property (weak, nonatomic) IBOutlet UIButton *profileSpotifyButton;
@property (weak, nonatomic) IBOutlet UILabel *currentlyPlaying;

- (IBAction)didTapProfileSpotify:(id)sender;

@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[SpotifyManager shared] accessToken] != nil) {
        self.currentlyPlaying.text = [@"Now Playing: " stringByAppendingString:[[SpotifyManager shared] trackName]];
    };
}

// Opens Spotify app with authentication page
- (IBAction)didTapSpotify:(id)sender {
    [[SpotifyManager shared] authenticateSpotify];
}
@end
