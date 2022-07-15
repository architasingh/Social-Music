//
//  FavoritesCell.h
//  Social-Music
//
//  Created by Archita Singh on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;

@end

NS_ASSUME_NONNULL_END
