//
//  ProfileDetailsViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/19/22.
//

#import "ProfileDetailsViewController.h"
#import <Parse/Parse.h>

@interface ProfileDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topArtistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *topSongsLabel;
@property (weak, nonatomic) IBOutlet UILabel *topArtistsHeader;
@property (weak, nonatomic) IBOutlet UILabel *topSongsHeader;

@property (strong, nonatomic) NSArray *otherUserTopArtists;
@property (strong, nonatomic) NSArray *otherUserTopSongs;
@property (strong, nonatomic) NSString *otherUser;

@property (strong, nonatomic) NSArray *currUserTopArtists;
@property (strong, nonatomic) NSArray *currUserTopSongs;

- (IBAction)didTapBack:(id)sender;
@end

@implementation ProfileDetailsViewController

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
    [self compareUserSongs];
    [self compareUserArtists];
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

- (void)compareUserSongs {
    NSLog(@"curr song %@", self.currUserTopSongs);
    NSLog(@"other song %@", self.otherUserTopSongs);
}

- (void)compareUserArtists {
    NSLog(@"curr artist %@", self.currUserTopArtists);
    NSLog(@"other artist %@", self.otherUserTopArtists);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// button action

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
