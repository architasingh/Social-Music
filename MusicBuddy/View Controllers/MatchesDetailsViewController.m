//
//  ProfileDetailsViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/19/22.
//

#import "MatchesDetailsViewController.h"
#import <Parse/Parse.h>

@interface MatchesDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topArtistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *topTracksLabel;
@property (weak, nonatomic) IBOutlet UILabel *topArtistsHeader;
@property (weak, nonatomic) IBOutlet UILabel *topTracksHeader;
@property (weak, nonatomic) IBOutlet UILabel *compatLabel;

@property (strong, nonatomic) NSArray *otherUserArtistNames;
@property (strong, nonatomic) NSArray *otherUserTrackNames;

@property (strong, nonatomic) NSString *otherUsername;

@property double artistScore;
@property double trackScore;
@property double perfectScore;

- (IBAction)didTapBack:(id)sender;
@end

@implementation MatchesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameLabel.text = [@"@" stringByAppendingString: self.otherUserInfo[@"username"]];
    self.otherUsername = self.otherUserInfo[@"username"];
    
    [self getTopDataforUser:self.otherUsername];
    [self getTopDataforUser:PFUser.currentUser.username];
}

- (void)viewDidAppear:(BOOL)animated {
    [self compareUserTopArtists]; //tracks called within artists
}

// Fetch user's top artists/tracks from database
- (void)getTopDataforUser:(NSString *)userType {
    PFQuery *query = [PFQuery queryWithClassName:@"SpotifyTopItemsData"];
    [query whereKey:@"username" equalTo:userType];
    [query findObjectsInBackgroundWithBlock:^(NSArray *topItems, NSError *error) {
        if (topItems != nil) {
            if ([userType isEqualToString:self.otherUsername]) {
                self.otherUserArtistNames = topItems[0][@"topArtistNames"];
                self.otherUserTrackNames = topItems[0][@"topTrackNames"];
                [self formatArtistTrackLabels];
            } else {
                self.currUserArtistNames = topItems[0][@"topArtistNames"];
                self.currUserTrackNames = topItems[0][@"topTrackNames"];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// Format artist/track labels
- (void)formatArtistTrackLabels {
    NSMutableArray *displayTracks = [[NSMutableArray alloc] init];
    NSMutableArray *displayArtists = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.otherUserArtistNames.count; i++) {
        [displayTracks addObject: [@"☆ " stringByAppendingString:self.otherUserTrackNames[i]]];
        [displayArtists addObject:[@"☆ " stringByAppendingString:self.otherUserArtistNames[i]]];
    }
    NSString *artistsString = [[displayArtists valueForKey:@"description"] componentsJoinedByString:@"\n"];
    NSString *tracksString = [[displayTracks valueForKey:@"description"] componentsJoinedByString:@"\n"];
    self.topArtistsLabel.text = artistsString;
    self.topTracksLabel.text = tracksString;
}

// Compare top artist information of two users and calculate their compatability
- (void)compareUserTopArtists {
    // Set artist scores for current and other users
    NSMutableDictionary *currUserArtistsDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *otherUserArtistsDict = [[NSMutableDictionary alloc] init];
    double artistBase = 10;
    for (int i = 0; i < self.currUserArtistNames.count; i++) {
        [currUserArtistsDict setObject:[NSDecimalNumber numberWithDouble: artistBase + 20 - i] forKey:self.currUserArtistNames[i]];
    }
    for (int i = 0; i < self.otherUserArtistNames.count; i++) {
        [otherUserArtistsDict setObject:[NSDecimalNumber numberWithDouble: artistBase + 20 - i] forKey:self.otherUserArtistNames[i]];
    }
    [self perfectScore:currUserArtistsDict];
    
    // Find the artists in common between the users
    NSMutableSet* artistSet1 = [NSMutableSet setWithArray:self.currUserArtistNames];
    NSMutableSet* artistSet2 = [NSMutableSet setWithArray:self.otherUserArtistNames];
    [artistSet1 intersectSet:artistSet2];
    NSArray* resultArtists = [artistSet1 allObjects];
    
    // Multiply the two users' scores for each match
    // Add all match scores and divide by the perfect score
    double sumOfProductsArtist = 0;
    for(NSString *object in resultArtists) {
        NSDecimalNumber *currScore = currUserArtistsDict[object];
        NSDecimalNumber *otherScore = otherUserArtistsDict[object];
        double product = ([currScore doubleValue] * [otherScore doubleValue]);
        sumOfProductsArtist += product;
    }
    self.artistScore = 100*(sumOfProductsArtist/self.perfectScore);
    [self compareUserTopTracks];
}

// Find the perfect score for the current user (same for artists + tracks)
- (void)perfectScore: (NSDictionary *)dict {
    NSDecimalNumber *positionScore = 0;
    self.perfectScore = 0;
    for (NSString *object in dict) {
        NSDecimalNumber *currScore = dict[object];
        positionScore = [currScore decimalNumberByMultiplyingBy:currScore];
        double positionScoreDouble = ([positionScore doubleValue]);
        self.perfectScore += positionScoreDouble;
    }
}

// Compare top track information of two users and calculate their compatability
- (void)compareUserTopTracks {
    // Set track scores for current and other users
    NSMutableDictionary *currUserTracksDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *otherUserTracksDict = [[NSMutableDictionary alloc] init];
    double trackBase = 10;
    for (int i = 0; i < self.currUserTrackNames.count; i++) {
        [currUserTracksDict setObject:[NSDecimalNumber numberWithDouble: trackBase + 20 - i] forKey:self.currUserTrackNames[i]];
    }
    for (int i = 0; i < self.otherUserTrackNames.count; i++) {
        [otherUserTracksDict setObject:[NSDecimalNumber numberWithDouble: trackBase + 20 - i] forKey:self.otherUserTrackNames[i]];
    }
    [self perfectScore:currUserTracksDict];
    
    // Find the tracks in common between the two users
    NSMutableSet* trackSet1 = [NSMutableSet setWithArray:self.currUserTrackNames];
    NSMutableSet* trackSet2 = [NSMutableSet setWithArray:self.otherUserTrackNames];
    [trackSet1 intersectSet:trackSet2];
    NSArray* resultTracks = [trackSet1 allObjects];
    
    // Multiply the two users' scores for each match
    // Add all match scores and divide by the perfect score
    double sumOfProductsTrack = 0;
    for(NSString *object in resultTracks) {
        NSDecimalNumber *currScore = currUserTracksDict[object];
        NSDecimalNumber *otherScore = otherUserTracksDict[object];
        double product = ([currScore doubleValue] * [otherScore doubleValue]);
        sumOfProductsTrack += product;
    }
    
    self.trackScore = 100*(sumOfProductsTrack/self.perfectScore);
    [self formatMatchLabel];
}

// Calculate total compatability score using artist and track scores
// Format match label and add fade-in animation
- (void)formatMatchLabel {
    double totalCompatability = ((.75 * self.artistScore) + (.25 * self.trackScore));
    NSDecimalNumber *totalCompatabilityNS = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:totalCompatability];
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                    scale:2
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    totalCompatabilityNS = [totalCompatabilityNS decimalNumberByRoundingAccordingToBehavior:behavior];
    NSString *totalCompatString = [[totalCompatabilityNS stringValue] stringByAppendingString: @"%"];
    NSTimeInterval duration = 0.35f;
    [UIView transitionWithView:self.compatLabel
                      duration:duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.compatLabel.text = [totalCompatString stringByAppendingString: @" Match!"];
                    } completion:nil];
}

// Dismiss details view
- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
