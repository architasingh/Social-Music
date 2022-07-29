//
//  SpotifyTopItemsData.m
//  Social-Music
//
//  Created by Archita Singh on 7/27/22.
//

#import "SpotifyTopItemsData.h"

@implementation SpotifyTopItemsData

@dynamic topArtistNames;
@dynamic topArtistPhotos;
@dynamic topTrackNames;
@dynamic topTrackPhotos;
@dynamic user;

+ (nonnull NSString *)parseClassName {
    return @"SpotifyTopItemsData";
}

- (instancetype)initWithTrackNames: (NSArray *)trackNames trackPhotos:(NSArray *)trackPhotos artistNames: (NSArray *)artistNames artistPhotos:(NSArray *)artistPhotos forUser: (PFUser *)user {
    self = [super init];
    self.topTrackNames = trackNames;
    self.topTrackPhotos = trackPhotos;
    self.topArtistNames = artistNames;
    self.topArtistPhotos = artistPhotos;
    self.user = user;
   
    return self;
}

+ (void) getResponseWithArtists: (NSDictionary *)artistData andTracks: (NSDictionary *)trackData withCompletion: (void (^)(void))completion {
    
    NSMutableArray *topArtistNames = [[NSMutableArray alloc] init];
    NSMutableArray *topArtistPhotos = [[NSMutableArray alloc] init];
    NSMutableArray *topTrackNames = [[NSMutableArray alloc] init];
    NSMutableArray *topTrackPhotos = [[NSMutableArray alloc] init];
    
        for (int i = 0; i < 20; i++) {
            NSString *artistName = artistData[@"items"][i][@"name"]; 
            NSString *artistPhoto = artistData[@"items"][i][@"images"][0][@"url"];

            [topArtistNames addObject:artistName];
            [topArtistPhotos addObject:artistPhoto];

            NSString *trackName = trackData[@"items"][i][@"name"];
            NSString *trackPhoto = trackData[@"items"][i][@"album"][@"images"][0][@"url"];

            [topTrackNames addObject:trackName];
            [topTrackPhotos addObject:trackPhoto];
        }
        
        PFUser *curr = PFUser.currentUser;
    
        SpotifyTopItemsData *STID = [[SpotifyTopItemsData alloc] initWithTrackNames:topTrackNames trackPhotos:topTrackPhotos artistNames:topArtistNames artistPhotos:topArtistPhotos forUser:curr];
        [STID saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        curr[@"status"] = @"saved";
        [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        NSLog(@"user data saved!");
    
        completion();
    }

@end
