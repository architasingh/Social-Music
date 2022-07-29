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
@property (nonatomic, strong) NSString *username;

- (instancetype)initWithTrackNames: (NSArray *)trackNames trackPhotos:(NSArray *)trackPhotos artistNames: (NSArray *)artistNames artistPhotos:(NSArray *)artistPhotos forUsername: (NSString *)username;

+ (void) getResponseWithArtists: (NSDictionary *)artistData andTracks: (NSDictionary *)trackData withCompletion: (void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
