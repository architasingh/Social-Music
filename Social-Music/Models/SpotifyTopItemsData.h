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
@property (nonatomic, strong) PFUser *user;

- (instancetype)initWithTrackNames: (NSArray *)trackNames trackPhotos:(NSArray *)trackPhotos artistNames: (NSArray *)artistNames artistPhotos:(NSArray *)artistPhotos forUser: (PFUser *)user;

+ (void) getResponseWithArtists: (NSDictionary *)artistData andTracks: (NSDictionary *)trackData withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
