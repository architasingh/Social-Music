//
//  FavoritesCell.h
//  Social-Music
//
//  Created by Archita Singh on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artistPhoto;

@end

NS_ASSUME_NONNULL_END
