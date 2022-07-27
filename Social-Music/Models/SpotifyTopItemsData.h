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
@property (nonatomic, strong) NSArray *topArtists;
@property (nonatomic, strong) NSArray *topTracks;

- (instancetype)initWithType: (NSString *)type data: (NSArray *)data forUser: (PFUser *)user;

+ (void) getResponseWithData: (NSDictionary *)data ofType: (NSString *)type withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
