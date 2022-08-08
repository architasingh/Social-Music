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

- (IBAction)didTapPrevious:(id)sender;
- (IBAction)didTapPausePlay:(id)sender;
- (IBAction)didTapSkip:(id)sender;

@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[SpotifyManager shared] accessToken] != nil) {
        [self formatNowPlaying];
    };
}

// Skip to next song
- (IBAction)didTapSkip:(id)sender {
    if ([[SpotifyManager shared] accessToken]) {
        [[[SpotifyManager shared] appRemote].playerAPI skipToNext:^(id  _Nullable result, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"failed");
                } else {
                    NSLog(@"succeeded");
                    [[[SpotifyManager shared] appRemote].playerAPI getPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"failed");
                        } else {
                            [self formatNowPlaying];
                            NSLog(@"succeeded");
                        }
                    }];
                }
        }];
    }
}

// Play or pause song
- (IBAction)didTapPausePlay:(id)sender {
    if ([[SpotifyManager shared] accessToken]) {
        self.pausePlayButton.selected = !self.pausePlayButton.selected;
        if (self.pausePlayButton.selected) {
            [[[SpotifyManager shared] appRemote].playerAPI pause:^(id  _Nullable result, NSError * _Nullable error) {
            }];
            [self formatPaused];
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
        [[[SpotifyManager shared] appRemote].playerAPI skipToPrevious:^(id  _Nullable result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"failed");
            } else {
                [[[SpotifyManager shared] appRemote].playerAPI getPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"failed");
                    } else {
                        [self formatNowPlaying];
                        NSLog(@"succeeded");
                    }
                }];
            }
        }];
    }
}

// Format text when song is playing
- (void)formatNowPlaying {
    NSString *nowPlaying = @"Now Playing: ";
    NSString *fullText = [@"Now Playing: " stringByAppendingString:[[SpotifyManager shared] trackName]];

    NSMutableAttributedString *boldedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:nowPlaying];
    [boldedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:boldRange];
    [self.currentlyPlaying setAttributedText: boldedString];
}

// Format text when song is paused
- (void)formatPaused {
    NSString *nowPlaying = @"Paused: ";
    NSString *fullText = [@"Paused: " stringByAppendingString:[[SpotifyManager shared] trackName]];

    NSMutableAttributedString *boldedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange boldRange = [fullText rangeOfString:nowPlaying];
    [boldedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:boldRange];
    [self.currentlyPlaying setAttributedText: boldedString];
}

@end
