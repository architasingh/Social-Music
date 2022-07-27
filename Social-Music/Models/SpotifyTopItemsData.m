//
//  SpotifyTopItemsData.m
//  Social-Music
//
//  Created by Archita Singh on 7/27/22.
//

#import "SpotifyTopItemsData.h"

@implementation SpotifyTopItemsData

@dynamic topTracks;
@dynamic topArtists;

+ (nonnull NSString *)parseClassName {
    return @"SpotifyTopItemsData";
}

- (instancetype)initWithType: (NSString *)type data: (NSArray *)data forUser: (PFUser *)user {
    self = [super init];
    if ([type isEqualToString:@"artists"]) {
        self.topArtists = data;
    } else {
        self.topTracks = data;
    }
   
    return self;
}

+ (void) getResponseWithData: (NSDictionary *)data ofType: (NSString *)type withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    NSMutableArray *topArtists = [[NSMutableArray alloc] init];
    NSMutableArray *topTracks = [[NSMutableArray alloc] init];
    
    if ([type isEqual: @"artists"]) {
        for (int i = 0; i < 20; i++) {
            NSString *artistName = data[@"items"][i][@"name"];
            NSString *artistPhoto = data[@"items"][i][@"images"][0][@"url"];
            
            Artist *artist = [Artist getArtist:artistName image:artistPhoto withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            }];
            
            [topArtists addObject:artist];
           
        }
        SpotifyTopItemsData *STID = [[SpotifyTopItemsData alloc] initWithType:@"artists" data:topArtists forUser:PFUser.currentUser];
        [STID saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
    
        //call completion
        
        return;
    } if ([type  isEqual: @"tracks"]) {
        for (int i = 0; i < 20; i++) {
            
            NSString *trackName = data[@"items"][i][@"name"];
            NSString *trackPhoto = data[@"items"][i][@"album"][@"images"][0][@"url"];
            
            Track *track = [Track getTrack:trackName image:trackPhoto withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            }];
            
            [topTracks addObject:track.name];
        }
        SpotifyTopItemsData *STID = [[SpotifyTopItemsData alloc] initWithType:@"tracks" data:topTracks forUser:PFUser.currentUser];
        [STID saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];

        //call completion
   
    }
}

@end
