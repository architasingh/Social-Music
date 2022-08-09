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
@dynamic username;

+ (nonnull NSString *)parseClassName {
    return @"SpotifyTopItemsData";
}

- (instancetype)initWithTrackNames: (NSArray *)trackNames trackPhotos:(NSArray *)trackPhotos artistNames: (NSArray *)artistNames artistPhotos:(NSArray *)artistPhotos forUsername: (NSString *)username {
    self = [super init];
    self.topTrackNames = trackNames;
    self.topTrackPhotos = trackPhotos;
    self.topArtistNames = artistNames;
    self.topArtistPhotos = artistPhotos;
    self.username = username;
   
    return self;
}

+ (void)getResponseWithArtists: (NSDictionary *)artistData andTracks: (NSDictionary *)trackData ofType: (NSString *)type withCompletion: (void (^)(void))completion {
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
        
    if ([type isEqualToString:(@"create")]) {
        SpotifyTopItemsData *STID = [[SpotifyTopItemsData alloc] initWithTrackNames:topTrackNames trackPhotos:topTrackPhotos artistNames:topArtistNames artistPhotos:topArtistPhotos forUsername:curr.username];
        [STID saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        curr[@"status"] = @"saved";
        [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        NSLog(@"user data saved!");
        completion();
    } 
    else if ([type isEqualToString:(@"update")]) {
        PFQuery *updateQuery = [PFQuery queryWithClassName:@"SpotifyTopItemsData"];
        [updateQuery whereKey:@"username" equalTo:PFUser.currentUser.username];
        [updateQuery findObjectsInBackgroundWithBlock:^(NSArray *topInfo, NSError *error) {
            if (topInfo != nil) {
                topInfo[0][@"topArtistNames"] = topArtistNames;
                topInfo[0][@"topTrackNames"] = topTrackNames;
                topInfo[0][@"topArtistPhotos"] = topArtistPhotos;
                topInfo[0][@"topTrackPhotos"] = topTrackPhotos;
                [topInfo[0] saveInBackground];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else {
        NSLog(@"Invalid request");
    }
}

@end
