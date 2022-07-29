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
    [self compareUserTop:@"artists"];
    [self compareUserTop:@"songs"];
}

// get top data

- (void)getTopDataforUser:(NSString *)userType {
    PFQuery *query = [PFQuery queryWithClassName:@"SpotifyTopItemsData"];
    [query whereKey:@"username" equalTo:self.otherUsername];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *topItems, NSError *error) {
        if (topItems != nil) {
            if ([userType isEqualToString:self.otherUsername]) {
                self.otherUserArtistNames = topItems[0][@"topArtistNames"];
                self.otherUserTrackNames = topItems[0][@"topTrackNames"];
                
                NSString *artistsString = [[self.otherUserArtistNames valueForKey:@"description"] componentsJoinedByString:@"\n"];
                NSString *tracksString = [[self.otherUserTrackNames valueForKey:@"description"] componentsJoinedByString:@"\n"];
                
                self.topArtistsLabel.text = artistsString;
                self.topTracksLabel.text = tracksString;
            } else {
                self.currUserArtistNames = topItems[0][@"topArtistNames"];
                self.currUserTrackNames = topItems[0][@"topTrackNames"];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// by now the fetching is done
- (void)compareUserTop:(NSString *) type {
    
    if ([type isEqualToString:@"artists"]) {
        NSMutableDictionary *currArtistDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *otherArtistDict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < self.currUserArtistNames.count; i++) {
            [currArtistDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/200.0)] forKey:self.currUserArtistNames[i]];
        }
        for (int i = 0; i < self.otherUserArtistNames.count; i++) {
            [otherArtistDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/200.0)] forKey:self.otherUserArtistNames[i]];
        }
        NSLog(@"curr artist dict: %@", currArtistDict);
        NSLog(@"other artist dict: %@", otherArtistDict);
        
        NSMutableSet* set1 = [NSMutableSet setWithArray:self.currUserArtistNames];
        NSMutableSet* set2 = [NSMutableSet setWithArray:self.otherUserArtistNames];
        [set1 intersectSet:set2];

        NSArray* result = [set1 allObjects];
        NSLog(@"artist result: %@", result);
        NSMutableArray *artistVal = [[NSMutableArray alloc] init];
        
        for(NSString *object in result) {
            NSDecimalNumber *indexCurr = currArtistDict[object];
            NSDecimalNumber *indexOther = otherArtistDict[object];
            NSDecimalNumber *diff = [indexCurr decimalNumberBySubtracting:indexOther];
            double diffDouble = fabs([diff doubleValue]);
            double artistWeight = ((1 - diffDouble)/20)*0.75;
            [artistVal addObject:[NSDecimalNumber numberWithDouble:artistWeight]];
        }
        
        double compatability = 0;
        for (NSDecimalNumber *artistInd in artistVal) {
            compatability += fabs([artistInd doubleValue]);
        }
        artistCompatability = compatability;
        
    } else {
        NSMutableDictionary *currTrackDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *otherTrackDict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < self.currUserTrackNames.count; i++) {
            [currTrackDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/200.0)] forKey:self.currUserTrackNames[i]];
        }
        for (int i = 0; i < self.otherUserTrackNames.count; i++) {
            [otherTrackDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/200.0)] forKey:self.otherUserTrackNames[i]];
        }
        
        NSLog(@"curr song Dict: %@", currTrackDict);
        NSLog(@"other song Dict: %@", otherTrackDict);
        
        NSMutableSet* set1 = [NSMutableSet setWithArray:self.currUserTrackNames];
        NSMutableSet* set2 = [NSMutableSet setWithArray:self.otherUserTrackNames];
        
        [set1 intersectSet:set2];

        NSArray *result = [set1 allObjects];
        NSLog(@"song result: %@", result);
        NSMutableArray *trackVal = [[NSMutableArray alloc] init];
        
        for(NSString *object in result) {
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
    }
    double totalCompatability = (artistCompatability + trackCompatability)*100;
    NSDecimalNumber *totalCompatabilityNS = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:totalCompatability];
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                    scale:3
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    totalCompatabilityNS = [totalCompatabilityNS decimalNumberByRoundingAccordingToBehavior:behavior];
    
    NSString *totalCompatString = [[totalCompatabilityNS stringValue] stringByAppendingString: @"%"];
    NSLog(@"total compatability: %@", totalCompatString);
    self.compatLabel.text = totalCompatString;
}

// button action

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
