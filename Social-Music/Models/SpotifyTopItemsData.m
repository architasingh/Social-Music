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


+ (nonnull NSString *)parseClassName {
    return @"SpotifyTopItemsData";
}

- (instancetype)initWithType: (NSString *)type names: (NSArray *)names photos: (NSArray *)photos forUser: (PFUser *)user {
    self = [super init];
    if ([type isEqualToString:@"artists"]) {
        self.topTrackNames = names;
        self.topTrackPhotos = photos;
    } else {
        self.topArtistNames = names;
        self.topArtistPhotos = photos;
    }
   
    return self;
}

+ (void) getResponseWithData: (NSDictionary *)data ofType: (NSString *)type withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    NSMutableArray *topArtistNames = [[NSMutableArray alloc] init];
    NSMutableArray *topArtistPhotos = [[NSMutableArray alloc] init];
    NSMutableArray *topTrackNames = [[NSMutableArray alloc] init];
    NSMutableArray *topTrackPhotos = [[NSMutableArray alloc] init];
    
    if ([type isEqual: @"artists"]) {
        for (int i = 0; i < 20; i++) {
            NSString *artistName = data[@"items"][i][@"name"];
            NSString *artistPhoto = data[@"items"][i][@"images"][0][@"url"];
            
            [topArtistNames addObject:artistName];
            [topArtistPhotos addObject:artistPhoto];
           
        }
        SpotifyTopItemsData *STID = [[SpotifyTopItemsData alloc] initWithType:@"artists" names:topArtistNames photos:topArtistPhotos forUser:PFUser.currentUser];
        [STID saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        
        return;
        
    } if ([type  isEqual: @"tracks"]) {
        for (int i = 0; i < 20; i++) {
            
            NSString *trackName = data[@"items"][i][@"name"];
            NSString *trackPhoto = data[@"items"][i][@"album"][@"images"][0][@"url"];
            
            [topTrackNames addObject:trackName];
            [topTrackPhotos addObject:trackPhoto];
        }
        SpotifyTopItemsData *STID = [[SpotifyTopItemsData alloc] initWithType:@"tracks" names:topTrackNames photos:topTrackPhotos forUser:PFUser.currentUser];
        [STID saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];

        //call completion
   
    }
}

@end
