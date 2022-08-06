//
//  ProfileDetailsViewController.m
//  Social-Music
//
//  Created by Archita Singh on 8/5/22.
//

#import "DiscoverViewController.h"
#import <Parse/Parse.h>

@interface DiscoverViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *relatedArtistsLabel;

- (IBAction)didTapBack:(id)sender;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDiscoverArray];

    // Do any additional setup after loading the view.
}

- (NSString *) returnArrayItem: (NSArray *) array {
    NSUInteger randNum = arc4random() % [array count];
    NSString *returnValue =  [array objectAtIndex:randNum];
    return returnValue;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
