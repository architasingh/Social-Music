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
#import "SpotifyManager.h"

@interface SongViewController ()

@property (weak, nonatomic) IBOutlet UIButton *spotifyButton;

- (IBAction)didTapSpotify:(id)sender;

@end

@implementation SongViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)didTapSpotify:(id)sender {
    [[SpotifyManager shared] authenticateSpotify];
}
@end
