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

- (IBAction)didTapBack:(id)sender;
@end

@implementation MatchesDetailsViewController
double artistCompatability;
double trackCompatability;

// view setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameLabel.text = [@"@" stringByAppendingString: self.otherUserInfo[@"username"]];
    NSLog(@"user %@", self.otherUserInfo);
    
    self.otherUsername = self.otherUserInfo[@"username"];
    NSLog(@"other user: %@",self.otherUsername);
    
    [self getTopDataforUser:self.otherUsername];
    [self getTopDataforUser:PFUser.currentUser.username];
}

- (void)viewDidAppear:(BOOL)animated {
    [self compareUserTop];
}

// get top data

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

- (void) formatArtistTrackLabels {
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

- (void)compareUserTop {
    NSMutableDictionary *currArtistDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *otherArtistDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.currUserArtistNames.count; i++) {
        [currArtistDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/20.0)] forKey:self.currUserArtistNames[i]];
    }
    for (int i = 0; i < self.otherUserArtistNames.count; i++) {
        [otherArtistDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/20.0)] forKey:self.otherUserArtistNames[i]];
    }
    NSLog(@"curr artist dict: %@", currArtistDict);
    NSLog(@"other artist dict: %@", otherArtistDict);
    
    NSMutableSet* artistSet1 = [NSMutableSet setWithArray:self.currUserArtistNames];
    NSMutableSet* artistSet2 = [NSMutableSet setWithArray:self.otherUserArtistNames];
    [artistSet1 intersectSet:artistSet2];

    NSArray* resultArtists = [artistSet1 allObjects];
    NSLog(@"artist result: %@", resultArtists);
    NSMutableArray *artistVal = [[NSMutableArray alloc] init];
    
    for(NSString *object in resultArtists) {
        NSDecimalNumber *indexCurr = currArtistDict[object];
        NSDecimalNumber *indexOther = otherArtistDict[object];
        NSDecimalNumber *diff = [indexCurr decimalNumberBySubtracting:indexOther];
        double diffDouble = fabs([diff doubleValue]);
        double artistWeight = ((1 - diffDouble)/20)*0.75;
        [artistVal addObject:[NSDecimalNumber numberWithDouble:artistWeight]];
    }
    
    artistCompatability = 0;
    for (NSDecimalNumber *artistInd in artistVal) {
        artistCompatability += fabs([artistInd doubleValue]);
    }
    
    NSMutableDictionary *currTrackDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *otherTrackDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.currUserTrackNames.count; i++) {
        [currTrackDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/20.0)] forKey:self.currUserTrackNames[i]];
        [otherTrackDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/20.0)] forKey:self.otherUserTrackNames[i]];
    }
    
    NSLog(@"curr song Dict: %@", currTrackDict);
    NSLog(@"other song Dict: %@", otherTrackDict);
    
    NSMutableSet* tracksSet1 = [NSMutableSet setWithArray:self.currUserTrackNames];
    NSMutableSet* tracksSet2 = [NSMutableSet setWithArray:self.otherUserTrackNames];
    
    [tracksSet1 intersectSet:tracksSet2];

    NSArray *resultTracks = [tracksSet1 allObjects];
    NSLog(@"song result: %@", resultTracks);
    NSMutableArray *trackVal = [[NSMutableArray alloc] init];
    
    for(NSString *object in resultTracks) {
        NSDecimalNumber *indexCurr = currTrackDict[object];
        NSDecimalNumber *indexOther = otherTrackDict[object];
        NSDecimalNumber *diff = [indexCurr decimalNumberBySubtracting:indexOther];
        double diffDouble = fabs([diff doubleValue]);
        double trackWeight = ((1 - diffDouble)/20)*0.25;
        [trackVal addObject:[NSDecimalNumber numberWithDouble:trackWeight]];
    }
    
    double compatability = 0;
    for (NSDecimalNumber *trackInd in trackVal) {
        compatability += fabs([trackInd doubleValue]);
    }
    trackCompatability = compatability;
    NSLog(@"song compatability: %f", compatability);

    double totalCompatability = (artistCompatability + trackCompatability)*500; //5 is multiplier, 100 is to convert to %
    if (totalCompatability > 100.00) {
        totalCompatability = 100.00;
    }
    NSDecimalNumber *totalCompatabilityNS = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:totalCompatability];
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                    scale:2
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    totalCompatabilityNS = [totalCompatabilityNS decimalNumberByRoundingAccordingToBehavior:behavior];
    
    NSString *totalCompatString = [[totalCompatabilityNS stringValue] stringByAppendingString: @"%"];
    NSLog(@"total compatability: %@", totalCompatString);
    
    NSTimeInterval duration = 0.35f;
    [UIView transitionWithView:self.compatLabel
                      duration:duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.compatLabel.text = [totalCompatString stringByAppendingString: @" Match!"];
                    } completion:nil];
    }

// button action

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
