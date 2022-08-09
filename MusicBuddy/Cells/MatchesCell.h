//
//  MatchesCell.h
//  Social-Music
//
//  Created by Archita Singh on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;

@end

NS_ASSUME_NONNULL_END
