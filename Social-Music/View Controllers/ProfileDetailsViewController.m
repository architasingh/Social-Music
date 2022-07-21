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
- (IBAction)didTapBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topInfoLabel;

@end

@implementation ProfileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameLabel.text = [@"@" stringByAppendingString: self.user[@"username"]];
    NSLog(@"user %@", self.user);
    
    [self getTopArtists];
    
    // Do any additional setup after loading the view.
}

- (void)getTopArtists {
    PFQuery *query = [PFQuery queryWithClassName:@"Artists"];
    [query whereKey:@"username" equalTo:self.user[@"username"]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *topArtists, NSError *error) {
        if (topArtists != nil) {
            NSString * result = [[topArtists valueForKey:@"description"] componentsJoinedByString:@""];
            self.topInfoLabel.text = result;
            NSLog(@"top artists%@", topArtists);
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
