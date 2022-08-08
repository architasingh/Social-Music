//
//  ProfileDetailsViewController.m
//  Social-Music
//
//  Created by Archita Singh on 8/5/22.
//

#import "DiscoverViewController.h"
#import <Parse/Parse.h>
#import "SpotifyManager.h"

@interface DiscoverViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *relatedArtistsLabel;

- (IBAction)didTapBack:(id)sender;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[SpotifyManager shared] accessToken]) {
        [self createDiscoverArray];
    } else {
        [self connectAlert];
    }

    // Do any additional setup after loading the view.
}

// Pick a random artist from the array and return it
- (NSString *)returnArrayItem: (NSArray *) array {
    NSUInteger randNum = arc4random() % [array count];
    NSString *returnValue =  [array objectAtIndex:randNum];
    return returnValue;
}

// Select one random artist from each of the top artists' related artists arrays to build an array of artists for the discover page
- (void)createDiscoverArray {
    NSString *currUsername = PFUser.currentUser.username;
    NSMutableArray *discoverArray = [[NSMutableArray alloc] init];

    PFQuery *query = [PFQuery queryWithClassName:@"RelatedArtists"];
    [query whereKey:@"username" equalTo:currUsername];
    [query findObjectsInBackgroundWithBlock:^(NSArray *relatedData, NSError *error) {
        if (!error) {
            NSArray *relatedArtistArray = relatedData[0][@"relatedArtists"];
            
            for (int i = 0; i < 20; i++) {
                [discoverArray addObject:[self returnArrayItem:relatedArtistArray[i]]];

                NSString *relatedArtistsString = [[discoverArray valueForKey:@"description"] componentsJoinedByString:@"\n"];
                self.relatedArtistsLabel.text = relatedArtistsString;
            }
      } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
}

// Dismiss details view
- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

// Send alert if user doesn't have an active Spotify session
- (void) connectAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Inactive Spotify Session"
                                message:@"Please authenticate with Spotify to discover new artists."
                                preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    UIAlertAction *connectAction = [UIAlertAction actionWithTitle:@"Connect to Spotify" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [[SpotifyManager shared] authenticateSpotify];
                            }];
    [alert addAction:connectAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

@end
