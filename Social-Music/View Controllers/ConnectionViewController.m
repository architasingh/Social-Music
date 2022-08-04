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
    // Do any additional setup after loading the view.
}

// Proceed to tab bar controller
- (IBAction)didTapNext:(id)sender {
    [self performSegueWithIdentifier:@"connectSegue" sender:self];
}

// Opens Spotify app with authentication page
- (IBAction)didTapSpotify:(id)sender {
    [[SpotifyManager shared] authenticateSpotify];
}

@end
