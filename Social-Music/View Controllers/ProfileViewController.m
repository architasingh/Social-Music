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
#import "MatchesDetailsViewController.h"
#import "Track.h"
#import "Artist.h"
#import "SpotifyTopItemsData.h"
#import "CustomRefresh.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;

@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

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
- (IBAction)didTapRefresh:(id)sender;

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
    [self.favoriteButton setTitle:@"Show Top Songs" forState:UIControlStateSelected];
    [self.favoriteButton setTitle:@"Show Top Artists" forState:UIControlStateNormal];
    
    self.favoritesTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.favoritesTableView.dataSource = self;
    
    [[CustomRefresh shared] customRefresh: self.favoritesTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.accessToken = [[SpotifyManager shared] accessToken];
    PFUser *curr = PFUser.currentUser;
    if (!([curr[@"status"] isEqualToString:@"saved"])) {
        [self fetchTopDataOfType:@"create" WithCompletion:^{
            [self queryTopData];
        }];
    } else {
        [self queryTopData];
    }
    [self.favoritesTableView reloadData];
}

// Fetch top artists and tracks from Spotify Web API
- (void)fetchTopDataOfType: (NSString *)type WithCompletion: (void(^)(void)) completion {
    NSString *token = [[SpotifyManager shared] accessToken];
    
    NSString *tokenType = @"Bearer";
    NSString *header = [NSString stringWithFormat:@"%@ %@", tokenType, token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *artistURLString = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:@"artists"];
    
    NSURL *artistURL = [NSURL URLWithString:artistURLString];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setURL:artistURL];
            
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *artistTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable artistData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSDictionary *artistDict = [NSJSONSerialization JSONObjectWithData:artistData options:0 error:nil];
                
                NSString *trackURLString = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:@"tracks"];
                
                NSURL *trackURL = [NSURL URLWithString:trackURLString];
                [request setValue:header forHTTPHeaderField:@"Authorization"];
                [request setURL:trackURL];
                        
                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDataTask *trackTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable trackData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    NSDictionary *trackDict = [NSJSONSerialization JSONObjectWithData:trackData options:0 error:nil];
                    
                    if ([type isEqualToString:@"create"]) {
                        [SpotifyTopItemsData getResponseWithArtists:artistDict andTracks:trackDict ofType:@"create" withCompletion:^{
                            completion();
                        }];
                    } else if ([type isEqualToString:@"update"]) {
                        [SpotifyTopItemsData getResponseWithArtists:artistDict andTracks:trackDict ofType:@"update" withCompletion:^{
                            completion();
                        }];
                    } else {
                        completion();
                    }
                }];
                [trackTask resume];
            }
        }];
    [artistTask resume];
}

// Query top artists/tracks from database
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

// Button displays one set of data when clicked initially, and another set of data when clicked again
- (IBAction)didTapFavoritesButton:(id)sender {
    self.favoriteButton.selected = !self.favoriteButton.selected;
    [self.favoritesTableView reloadData];
}

// Refreshes user's top data
- (IBAction)didTapRefresh:(id)sender {
    if ([[[SpotifyManager shared] accessToken] isEqualToString:@""]) {
        [self spotifyAlert];
    } else {
        static int num = 0;
        self.refreshButton.transform = CGAffineTransformMakeRotation(M_PI * num);
        num++;
        
        [self fetchTopDataOfType:@"update" WithCompletion:^{
            [self queryTopData];
        }];
    }
}

// Send alert if user doesn't have an active Spotify session
- (void) spotifyAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Inactive Spotify Session Alert"
                                message:@"To refresh your top data, please click on the 'Connect to Spotify' button first."
                                preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Connect to Spotify" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [[SpotifyManager shared] authenticateSpotify];
                            }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

// Logs out current user
- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    
    SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mySceneDelegate.window.rootViewController = loginViewController;
}

// Sets profile image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profileImage.image = editedImage;
    
    PFUser *user = PFUser.currentUser;
    user[@"profilePicture"] = [self getPFFileFromImage:self.profileImage.image];
    [user saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Sets image from camera roll
- (IBAction)didTapCameraRoll:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];

    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

// Sets image from camera
- (IBAction)didTapTakePhoto:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

// Creates PFFile from image data
- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }

    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

// Shakes tableView cells
- (void)cellAnimation: (UITableViewCell *)cell {
    CAKeyframeAnimation *shakeCells = [CAKeyframeAnimation animation];
    shakeCells.keyPath = @"position.x";
    shakeCells.values = @[ @0, @10, @-10, @10, @0 ];
    shakeCells.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    shakeCells.duration = 0.4;
    shakeCells.additive = YES;
    [cell.layer addAnimation:shakeCells forKey:@"shake"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self cellAnimation:cell];

    if (!self.favoriteButton.isSelected) {
        Track *track = self.currUserTrackData[indexPath.row];
        cell.favoriteLabel.text = track.name;
        cell.favPhoto.image = track.photo;
        return cell;
    } else {
        Artist *artist = self.currUserArtistData[indexPath.row];
        cell.favoriteLabel.text = artist.name;
        cell.favPhoto.image = artist.photo;
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currUserArtistNames.count;
}

@end
