//
//  ProfileDetailsViewController.h
//  Social-Music
//
//  Created by Archita Singh on 7/19/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchesDetailsViewController : UIViewController

@property (strong, nonatomic) NSDictionary *otherUserInfo;
@property (strong, nonatomic) NSArray *currUserArtistNames;
@property (strong, nonatomic) NSArray *currUserTrackNames;

@end

NS_ASSUME_NONNULL_END
