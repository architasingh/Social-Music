//
//  MatchesViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "MatchesViewController.h"
#import "MatchesCell.h"
#import <Parse/Parse.h>
#import "MatchesDetailsViewController.h"
#import "KafkaRingIndicatorHeader.h"
#import "KafkaRefresh.h"

@interface MatchesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *matchesLabel;
@property (weak, nonatomic) IBOutlet UITableView *matchesTableView;
@property (strong, nonatomic) NSMutableArray *users;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.matchesTableView.rowHeight = 100;
    self.matchesTableView.dataSource = self;
    self.matchesTableView.delegate = self;
    
    [self displayUsers];
    
    KafkaRingIndicatorHeader * circle = [[KafkaRingIndicatorHeader alloc] init];
    [self kafkaRefresh:circle];
}

- (void) kafkaRefresh:(KafkaRingIndicatorHeader *)circle {
    circle.themeColor = UIColor.systemIndigoColor;
    circle.animatedBackgroundColor = UIColor.systemTealColor;
    __weak KafkaRingIndicatorHeader *weakCircle = circle;
    circle.refreshHandler = ^{
        [self.matchesTableView reloadData];
        [weakCircle endRefreshing];
    };
     self.matchesTableView.headRefreshControl = circle;
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
      } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.matchesTableView indexPathForCell:(UITableViewCell *)sender];
    NSArray *user = self.users[indexPath.row];
    MatchesDetailsViewController *detailVC = [segue destinationViewController];
    detailVC.otherUserInfo = (NSDictionary*)user;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchesCell" forIndexPath:indexPath];
    
    cell.userLabel.text = [@"@" stringByAppendingString: self.users[indexPath.row][@"username"]];
    NSLog(@"username: %@", cell.userLabel.text);

    cell.userImage.file = self.users[indexPath.row][@"profilePicture"];
    [cell.userImage loadInBackground];
    
    cell.userImage.layer.cornerRadius = 45;
    cell.userImage.layer.masksToBounds = YES;
    [cell.userImage loadInBackground];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

@end
