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
@property (weak, nonatomic) IBOutlet UILabel *topSongsLabel;
@property (weak, nonatomic) IBOutlet UILabel *topArtistsHeader;
@property (weak, nonatomic) IBOutlet UILabel *topSongsHeader;
@property (weak, nonatomic) IBOutlet UILabel *compatLabel;

@property (strong, nonatomic) NSArray *otherUserTopArtists;
@property (strong, nonatomic) NSArray *otherUserTopSongs;
@property (strong, nonatomic) NSString *otherUser;

@property (strong, nonatomic) NSArray *currUserTopArtists;
@property (strong, nonatomic) NSArray *currUserTopSongs;

- (IBAction)didTapBack:(id)sender;
@end

@implementation MatchesDetailsViewController
double artistCompatability;
double songCompatability;

// view setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameLabel.text = [@"@" stringByAppendingString: self.user[@"username"]];
    NSLog(@"user %@", self.user);
    
    self.otherUser = self.user[@"username"];
    
    [self getTopData:@"Songs" forUser:self.otherUser];
    [self getTopData:@"Artists" forUser:self.otherUser];
    
    PFUser *currUser = PFUser.currentUser;
    
    [self getTopData:@"Songs" forUser:currUser.username];
    [self getTopData:@"Artists" forUser:currUser.username];
}

- (void)viewDidAppear:(BOOL)animated {
    [self compareUserTop:@"artists"];
    [self compareUserTop:@"songs"];
}

// get top data

- (void)getTopData:(NSString *)type forUser:(NSString *)userType {
    PFQuery *query = [PFQuery queryWithClassName:type];
    [query whereKey:@"username" equalTo:userType];

    [query findObjectsInBackgroundWithBlock:^(NSArray *topItems, NSError *error) {
        if (topItems != nil) {
            NSString *result = [[topItems[0][@"text"] valueForKey:@"description"] componentsJoinedByString:@"\n"];
            if ([type isEqualToString:@"Artists"]) {
                if([userType isEqualToString:self.otherUser]) {
                    self.otherUserTopArtists = topItems[0][@"text"];
                    self.topArtistsLabel.text = result;
                } else {
                    self.currUserTopArtists = topItems[0][@"text"];
                }
            } else {
                if([userType isEqualToString:self.otherUser]) {
                    self.otherUserTopSongs = topItems[0][@"text"];
                    self.topSongsLabel.text = result;
                } else {
                    self.currUserTopSongs = topItems[0][@"text"];
                }
            }
//            NSLog(@"top: %@", topItems[0][@"text"]);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)compareUserTop:(NSString *) type {
    
    if ([type isEqualToString:@"artists"]) {
        NSMutableDictionary *currArtistDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *otherArtistDict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < self.currUserTopArtists.count; i++) {
            [currArtistDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/200.0)] forKey:self.currUserTopArtists[i]];
        }
        for (int i = 0; i < self.otherUserTopArtists.count; i++) {
            [otherArtistDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/200.0)] forKey:self.otherUserTopArtists[i]];
        }
        NSLog(@"curr artist dict: %@", currArtistDict);
        NSLog(@"other artist dict: %@", otherArtistDict);
        
        NSMutableSet* set1 = [NSMutableSet setWithArray:self.currUserTopArtists];
        NSMutableSet* set2 = [NSMutableSet setWithArray:self.otherUserTopArtists];
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
        NSMutableDictionary *currSongDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *otherSongDict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < self.currUserTopSongs.count; i++) {
            [currSongDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/200.0)] forKey:self.currUserTopSongs[i]];
        }
        for (int i = 0; i < self.otherUserTopSongs.count; i++) {
            [otherSongDict setObject:[NSDecimalNumber numberWithDouble:((i+1)/200.0)] forKey:self.otherUserTopSongs[i]];
        }
        
        NSLog(@"curr song Dict: %@", currSongDict);
        NSLog(@"other song Dict: %@", otherSongDict);
        
        NSMutableSet* set1 = [NSMutableSet setWithArray:self.currUserTopSongs];
        NSMutableSet* set2 = [NSMutableSet setWithArray:self.otherUserTopSongs];
        
        [set1 intersectSet:set2];

        NSArray *result = [set1 allObjects];
        NSLog(@"song result: %@", result);
        NSMutableArray *songVal = [[NSMutableArray alloc] init];
        
        for(NSString *object in result) {
            NSDecimalNumber *indexCurr = currSongDict[object];
            NSDecimalNumber *indexOther = otherSongDict[object];
            NSDecimalNumber *diff = [indexCurr decimalNumberBySubtracting:indexOther];
            double diffDouble = fabs([diff doubleValue]);
            double songWeight = ((1 - diffDouble)/20)*0.25;
            [songVal addObject:[NSDecimalNumber numberWithDouble:songWeight]];
        }
        
        double compatability = 0;
        for (NSDecimalNumber *songInd in songVal) {
            compatability += fabs([songInd doubleValue]);
        }
        songCompatability = compatability;
        NSLog(@"song compatability: %f", compatability);
    }
    double totalCompatability = (artistCompatability + songCompatability)*100;
    NSDecimalNumber *totalCompatabilityNS = [NSDecimalNumber numberWithDouble:totalCompatability];
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
