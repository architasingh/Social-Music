//
//  ConnectionViewController.m
//  Social-Music
//
//  Created by Archita Singh on 8/4/22.
//

#import "ConnectionViewController.h"
#import "SpotifyManager.h"

@interface ConnectionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *spotifyButton;

- (IBAction)didTapSpotify:(id)sender;
- (IBAction)didTapNext:(id)sender;

@end

@implementation ConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nextButton.tintColor = [UIColor colorWithRed:0.004 green:0.098 blue:0.212 alpha:1.000];
    self.spotifyButton.tintColor = [UIColor colorWithRed:0.004 green:0.098 blue:0.212 alpha:1.000];
}

// Proceed to tab bar controller
- (IBAction)didTapNext:(id)sender {    
    [self performSegueWithIdentifier:@"connectSegue" sender:self];
}

// Open Spotify app with authentication page
- (IBAction)didTapSpotify:(id)sender {
    [[SpotifyManager shared] authenticateSpotify];
}

@end
