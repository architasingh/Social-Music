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

@property (weak, nonatomic) IBOutlet UILabel *currentlyPlaying;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *pausePlayButton;
@property (weak, nonatomic) IBOutlet UIImageView *trackImage;

- (IBAction)didTapPrevious:(id)sender;
- (IBAction)didTapPausePlay:(id)sender;
- (IBAction)didTapSkip:(id)sender;

@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(formatNowPlaying) name:@"SpotifyManagerImageDidChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[SpotifyManager shared] accessToken] != nil) {
        [self formatNowPlaying];
        self.trackImage.image = [[SpotifyManager shared] trackImage];
    };
}

// Skip to next song
- (IBAction)didTapSkip:(id)sender {
    if ([[SpotifyManager shared] accessToken]) {
        [[[SpotifyManager shared] appRemote].playerAPI skipToNext:nil];
    }
}

// Play or pause song
- (IBAction)didTapPausePlay:(id)sender {
    if ([[SpotifyManager shared] accessToken]) {
        self.pausePlayButton.selected = !self.pausePlayButton.selected;
        if (self.pausePlayButton.selected) {
            [[[SpotifyManager shared] appRemote].playerAPI pause:^(id  _Nullable result, NSError * _Nullable error) {
            }];
            [self formatNowPlaying];
        } else {
            [[[SpotifyManager shared] appRemote].playerAPI resume:^(id  _Nullable result, NSError * _Nullable error) {
            }];
            [self formatNowPlaying];
        }
    }
}

// Go to previous song
- (IBAction)didTapPrevious:(id)sender {
    if ([[SpotifyManager shared] accessToken]) {
        [[[SpotifyManager shared] appRemote].playerAPI skipToPrevious:nil];
    }
}

// Format text and display image of song that's playing
- (void)formatNowPlaying {
    if (self.pausePlayButton.selected) {
        [self formatPaused];
    } else {
        self.trackImage.image = [[SpotifyManager shared] trackImage];
        
        NSString *nowPlaying = @"Now Playing: ";
        NSString *fullText = [@"Now Playing: " stringByAppendingString:[[SpotifyManager shared] trackName]];

        NSMutableAttributedString *boldedString = [[NSMutableAttributedString alloc] initWithString:fullText];
        NSRange boldRange = [fullText rangeOfString:nowPlaying];
        [boldedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:boldRange];
        [self.currentlyPlaying setAttributedText: boldedString];
    }
}

// Format text and display image of paused song
- (void)formatPaused {
    self.trackImage.image = [[SpotifyManager shared] trackImage];
    
    NSString *nowPlaying = @"Paused: ";
    NSString *fullText = [@"Paused: " stringByAppendingString:[[SpotifyManager shared] trackName]];

    NSMutableAttributedString *boldedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:nowPlaying];
    [boldedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:boldRange];
    [self.currentlyPlaying setAttributedText: boldedString];
}

@end
