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
    
    //self.topInfoLabel.text = self.user[@"topSongs"];
    //NSLog(@"details user: %@", topSongs);
    //Do any additional setup after loading the view.
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
