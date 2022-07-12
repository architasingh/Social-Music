//
//  ProfileViewController.h
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (nonatomic, strong) NSMutableArray *arrayOfFavorites;

- (IBAction)didTapTakePhoto:(id)sender;
- (IBAction)didTapCameraRoll:(id)sender;
- (IBAction)didTapLogout:(id)sender;


@end

NS_ASSUME_NONNULL_END
