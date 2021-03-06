//
//  ProfileViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "FavoritesCell.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "SpotifyManager.h"
#import "Parse/PFImageView.h"
#import "TopItems.h"
#import "MatchesDetailsViewController.h"
#import "Track.h"
#import "Artist.h"
#import "KafkaRingIndicatorHeader.h"
#import "KafkaRefresh.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;

@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic, strong) NSMutableArray *currUserArtistData;
@property (nonatomic, strong) NSMutableArray *currUserTrackData;

@property (nonatomic, strong) NSArray *currUserArtistNames;
@property (nonatomic, strong) NSArray *currUserTrackNames;
@property (nonatomic, strong) NSArray *currUserArtistPhotos;
@property (nonatomic, strong) NSArray *currUserTrackPhotos;

@property (nonatomic, strong) NSString *accessToken;

- (IBAction)didTapTakePhoto:(id)sender;
- (IBAction)didTapCameraRoll:(id)sender;
- (IBAction)didTapLogout:(id)sender;

@end

@implementation ProfileViewController


// view setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = PFUser.currentUser;
    self.currUserTrackData = [[NSMutableArray alloc] init];
    self.currUserArtistData = [[NSMutableArray alloc] init];
    
    self.usernameLabel.text = [@"@" stringByAppendingString: user.username];
    
    self.profileImage.file = user[@"profilePicture"];
    [self.profileImage loadInBackground];
    
    self.favoritesTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    KafkaRingIndicatorHeader * circle = [[KafkaRingIndicatorHeader alloc] init];
    [self kafkaRefresh:circle];
    
    [self.favoriteButton setTitle:@"Show Top Songs" forState:UIControlStateSelected];
    [self.favoriteButton setTitle:@"Show Top Artists" forState:UIControlStateNormal];
    
    self.favoritesTableView.dataSource = self;
}

- (void) kafkaRefresh:(KafkaRingIndicatorHeader *)circle {
    circle.themeColor = UIColor.systemIndigoColor;
    circle.animatedBackgroundColor = UIColor.systemTealColor;
    __weak KafkaRingIndicatorHeader *weakCircle = circle;
    circle.refreshHandler = ^{
        [self.favoritesTableView reloadData];
        [weakCircle endRefreshing];
    };
     self.favoritesTableView.headRefreshControl = circle;
}

- (void)viewDidAppear:(BOOL)animated {
    self.accessToken = [[SpotifyManager shared] accessToken];
    NSLog(@"access token: %@", self.accessToken);
    
    PFUser *curr = PFUser.currentUser;
//    curr[@"status"] = @"";
    NSLog(@"current status: %@",curr[@"status"]);
    
    if (!([curr[@"status"] isEqualToString:@"saved"])) {
        [[TopItems shared] fetchTopDataWithCompletion:^{
        }];
        [self queryTopData];
    } else {
        [self queryTopData];
    }
    [self.favoritesTableView reloadData];
}

- (void)queryTopData {
    PFQuery *topInfoQuery = [PFQuery queryWithClassName:@"SpotifyTopItemsData"];
    [topInfoQuery whereKey:@"username" equalTo:PFUser.currentUser.username];
    [topInfoQuery findObjectsInBackgroundWithBlock:^(NSArray *topInfo, NSError *error) {
        if (topInfo != nil) {
            self.currUserArtistNames = topInfo[0][@"topArtistNames"];
            self.currUserTrackNames = topInfo[0][@"topTrackNames"];
            self.currUserArtistPhotos = topInfo[0][@"topArtistPhotos"];
            self.currUserTrackPhotos = topInfo[0][@"topTrackPhotos"];
            self.currUserTrackData = [Track buildArrayofTracks:self.currUserTrackNames withPhotos:self.currUserTrackPhotos];
            self.currUserArtistData = [Artist buildArrayofArtists:self.currUserArtistNames withPhotos:self.currUserArtistPhotos];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// button actions

- (IBAction)didTapFavoritesButton:(id)sender {
    self.favoriteButton.selected = !self.favoriteButton.selected;
    [self.favoritesTableView reloadData];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    
    SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mySceneDelegate.window.rootViewController = loginViewController;
}

// image set up (move)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.profileImage.image = editedImage;
    
    PFUser *user = PFUser.currentUser;
    user[@"profilePicture"] = [self getPFFileFromImage:self.profileImage.image];
    [user saveInBackground];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCameraRoll:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.

    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)didTapTakePhoto:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera ???? available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {

    // check if image is not nil
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }

    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

// tableview methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CAKeyframeAnimation *shakeCells = [CAKeyframeAnimation animation];
    shakeCells.keyPath = @"position.x";
    shakeCells.values = @[ @0, @10, @-10, @10, @0 ];
    shakeCells.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    shakeCells.duration = 0.4;

    shakeCells.additive = YES;

    [cell.layer addAnimation:shakeCells forKey:@"shake"];

    if (!self.favoriteButton.isSelected) {
        Track *track = self.currUserTrackData[indexPath.row];
        
        cell.favoriteLabel.text = track.name;
        cell.favPhoto.image = track.photo;
        
        NSLog(@"artist: %@", track.name);
        NSLog(@"artist: %@", track.photo);

        return cell;
    } else {
        Artist *artist = self.currUserArtistData[indexPath.row];
        cell.favoriteLabel.text = artist.name;
        cell.favPhoto.image = artist.photo;
       
        NSLog(@"artist: %@", artist.name);
        NSLog(@"artist: %@", artist.photo);
        
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currUserArtistNames.count;
}

@end
