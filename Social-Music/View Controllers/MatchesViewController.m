//
//  MatchesViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "MatchesViewController.h"
#import "MatchesCell.h"
#import <Parse/Parse.h>

@interface MatchesViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *matchesLabel;
@property (weak, nonatomic) IBOutlet UITableView *matchesTableView;
@property (strong, nonatomic) NSMutableArray *users;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.matchesTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    self.matchesTableView.dataSource = self;
    
    [self displayUsers];
//    [self.matchesTableView reloadData];
}

- (void) displayUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.users = [[NSMutableArray alloc] init];
            for (PFUser *object in objects) {
                [self.users addObject:object[@"username"]];
            }
            [self.matchesTableView reloadData];
            NSLog(@"Users: %@", self.users);
      } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchesCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userLabel.text = [@"@" stringByAppendingString: self.users[indexPath.row]];
    NSLog(@"user: %@",self.users);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

@end
