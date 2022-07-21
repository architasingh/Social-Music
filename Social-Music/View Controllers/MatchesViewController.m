//
//  MatchesViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "MatchesViewController.h"
#import "MatchesCell.h"
#import <Parse/Parse.h>
#import "ProfileDetailsViewController.h"

@interface MatchesViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *matchesLabel;
@property (weak, nonatomic) IBOutlet UITableView *matchesTableView;
@property (strong, nonatomic) NSMutableArray *users;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.matchesTableView.rowHeight = 100;
    self.matchesTableView.dataSource = self;
    
    [self displayUsers];
}

- (void) displayUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *matchUsers, NSError *error) {
        if (!error) {
            self.users = [[NSMutableArray alloc] init];
            for (PFUser *matchUser in matchUsers) {
                if (!([matchUser.username isEqualToString:PFUser.currentUser.username])) {
                    [self.users addObject:matchUser];
                }
            }
            [self.matchesTableView reloadData];
//            NSLog(@"Users: %@", self.users);
      } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.matchesTableView indexPathForCell:(UITableViewCell *)sender];
    NSArray *user = self.users[indexPath.row];
    ProfileDetailsViewController *detailVC = [segue destinationViewController];
    detailVC.user = (NSDictionary*)user;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchesCell" forIndexPath:indexPath];
    
    //deselect after tapping
    cell.userLabel.text = [@"@" stringByAppendingString: self.users[indexPath.row][@"username"]];

    cell.userImage.file = self.users[indexPath.row][@"profilePicture"];
    
    cell.userImage.layer.cornerRadius = 45;
    cell.userImage.layer.masksToBounds = YES;
    [cell.userImage loadInBackground];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

@end
