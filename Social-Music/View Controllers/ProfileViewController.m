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

@interface ProfileViewController () <UIImagePickerControllerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic, strong) NSArray *artistData;
@property (nonatomic, strong) NSArray *trackData;
@property (nonatomic, strong) NSString *accessToken;
@property Boolean *saved;

- (IBAction)didTapTakePhoto:(id)sender;
- (IBAction)didTapCameraRoll:(id)sender;
- (IBAction)didTapLogout:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = PFUser.currentUser;
    self.usernameLabel.text = [@"@" stringByAppendingString: user.username];
    
    self.profileImage.file = user[@"profilePicture"];
    [self.profileImage loadInBackground];
    
    self.favoritesTableView.dataSource = self;
    [self.favoritesTableView reloadData];
    
    self.favoritesTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
       [self.favoritesTableView insertSubview:refreshControl atIndex:0];
    
    [self.favoriteButton setTitle:@"Top Songs" forState:UIControlStateSelected];
    [self.favoriteButton setTitle:@"Top Artists" forState:UIControlStateNormal];
    self.saved = FALSE;
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.accessToken = [[SpotifyManager shared] accessToken];
    if (self.saved == FALSE) {
        [self fetchTopData:@"artists"];
        [self fetchTopData:@"tracks"];
        self.saved = TRUE;
    }
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    self.favoritesTableView.dataSource = self;

    [self.favoritesTableView reloadData];
    [refreshControl endRefreshing];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    PFImageView *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.profileImage = editedImage;
    
    PFUser *user = PFUser.currentUser;
    user[@"profilePicture"] = [self getPFFileFromImage:self.profileImage];
    [user saveInBackground];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    
    SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mySceneDelegate.window.rootViewController = loginViewController;
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
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)didTapArtistButton:(id)sender {
    self.favoriteButton.selected = !self.favoriteButton.selected;
    [self.favoritesTableView reloadData];
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

- (void)fetchTopData:(NSString *)type {
    NSString *token = self.accessToken;
    
    NSString *tokenType = @"Bearer";
    NSString *header = [NSString stringWithFormat:@"%@ %@", tokenType, token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *baseURL = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:type];
    NSURL *url = [NSURL URLWithString:baseURL];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setURL:url];
            
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([type  isEqual: @"artists"]) {
                    self.artistData = dataDictionary[@"items"];
                    [self saveTopArtists];
                } if ([type  isEqual: @"tracks"]) {
                    self.trackData = dataDictionary[@"items"];
                    [self saveTopSongs];
                }
            }
        }] resume];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    if (self.favoriteButton.isSelected) {
        cell.favoriteLabel.text = self.artistData[indexPath.row][@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else { // if song button/nothing is selected
        cell.favoriteLabel.text = self.trackData[indexPath.row][@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void) saveTopSongs {
    PFObject *topSongs = [PFObject objectWithClassName:@"Songs"];
    NSMutableArray *topSongsArray = [NSMutableArray new];
    for (int i = 0; i < self.trackData.count; i++) {
        [topSongsArray addObject:self.trackData[i][@"name"]];
    }
    NSLog(@"top songs: %@", topSongsArray);
    topSongs[@"text"] = topSongsArray;
    topSongs[@"user"] = PFUser.currentUser;
    [topSongs saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The song data was saved!");
            } else {
                NSLog(@"Problem saving song data: %@", error.localizedDescription);
            }
        }];
}

- (void) saveTopArtists {
    PFObject *topArtists = [PFObject objectWithClassName:@"Artists"];
    NSMutableArray *topArtistsArray = [NSMutableArray new];
    for (int i = 0; i < self.artistData.count; i++) {
        [topArtistsArray addObject:self.artistData[i][@"name"]];
    }
    NSLog(@"top artists: %@", topArtistsArray);
    topArtists[@"text"] = topArtistsArray;
    topArtists[@"user"] = PFUser.currentUser;
    [topArtists saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The artist data was saved!");
            } else {
                NSLog(@"Problem saving artist data: %@", error.localizedDescription);
            }
        }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artistData.count;
}

@end
