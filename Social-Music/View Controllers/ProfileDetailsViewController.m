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

- (IBAction)didTapBack:(id)sender;
@end

@implementation ProfileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameLabel.text = [@"@" stringByAppendingString: self.user[@"username"]];
    NSLog(@"user %@", self.user);
    
    [self fetchTopData:@"Artists"];
    [self fetchTopData:@"Songs"];
    
    // Do any additional setup after loading the view.
}
- (void)fetchTopData:(NSString *)type {
    PFQuery *query = [PFQuery queryWithClassName:type];
    [query whereKey:@"username" equalTo:self.user[@"username"]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *topItems, NSError *error) {
        if (topItems != nil) {
            NSString *result = [[topItems[0][@"text"] valueForKey:@"description"] componentsJoinedByString:@"\n"];
            if ([type isEqualToString:@"Artists"]) {
                self.topArtistsLabel.text = result;
            } else {
                self.topSongsLabel.text = result;
            }
            NSLog(@"top: %@", topItems[0][@"text"]);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
