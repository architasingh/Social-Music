//
//  SpotifyTopItemsData.h
//  Social-Music
//
//  Created by Archita Singh on 7/27/22.
//

#import <Parse/Parse.h>
#import "Artist.h"
#import "Track.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyTopItemsData : PFObject<PFSubclassing>
@property (nonatomic, strong) NSArray *topArtistNames;
@property (nonatomic, strong) NSArray *topArtistPhotos;
@property (nonatomic, strong) NSArray *topTrackNames;
@property (nonatomic, strong) NSArray *topTrackPhotos;

- (instancetype)initWithType: (NSString *)type names: (NSArray *)names photos: (NSArray *)photos forUser: (PFUser *)user;

+ (void) getResponseWithData: (NSDictionary *)data ofType: (NSString *)type withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
