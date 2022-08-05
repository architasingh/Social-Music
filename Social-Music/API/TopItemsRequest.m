//
//  TopItemsRequest.m
//  Social-Music
//
//  Created by Archita Singh on 8/3/22.
//

#import "TopItemsRequest.h"
#import "SpotifyManager.h"
#import "SpotifyTopItemsData.h"
#import "Artist.h"

@implementation TopItemsRequest

NSMutableDictionary *relatedDict;

- (id)init {
    if ((self = [super init]) ) {
        relatedDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// Fetch top artists and tracks from Spotify Web API
- (void)fetchTopDataOfType: (NSString *)type WithCompletion: (void(^)(void)) completion {
    NSString *token = [[SpotifyManager shared] accessToken];
    
    NSString *tokenType = @"Bearer";
    NSString *header = [NSString stringWithFormat:@"%@ %@", tokenType, token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *artistURLString = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:@"artists"];
    
    NSURL *artistURL = [NSURL URLWithString:artistURLString];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setURL:artistURL];
            
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *artistTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable artistData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSDictionary *artistDict = [NSJSONSerialization JSONObjectWithData:artistData options:0 error:nil];
                
//                get related artists
                [self getRelatedArtistsWithDict:artistDict];
                
                NSString *trackURLString = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:@"tracks"];
                
                NSURL *trackURL = [NSURL URLWithString:trackURLString];
                [request setValue:header forHTTPHeaderField:@"Authorization"];
                [request setURL:trackURL];
                        
                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDataTask *trackTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable trackData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    NSDictionary *trackDict = [NSJSONSerialization JSONObjectWithData:trackData options:0 error:nil];
                    
                    if ([type isEqualToString:@"create"]) {
                        [SpotifyTopItemsData getResponseWithArtists:artistDict andTracks:trackDict ofType:@"create" withCompletion:^{
                            completion();
                        }];
                    } else if ([type isEqualToString:@"update"]) {
                        [SpotifyTopItemsData getResponseWithArtists:artistDict andTracks:trackDict ofType:@"update" withCompletion:^{
                            completion();
                        }];
                    } else {
                        completion();
                    }
                }];
                [trackTask resume];
            }
        }];
    [artistTask resume];
}

- (void)getRelatedArtistsWithDict:(NSDictionary *)dict {
    for (int i = 0; i < 20; i ++) {

        NSString *artistID = dict[@"items"][i][@"id"];
        
        NSString *token = [[SpotifyManager shared] accessToken];
        NSString *tokenType = @"Bearer";
        NSString *header = [NSString stringWithFormat:@"%@ %@", tokenType, token];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

        NSString *baseURL = @"https://api.spotify.com/v1/artists/";
        NSString *addID = [baseURL stringByAppendingString:artistID];
        NSURL *idURL = [NSURL URLWithString:[addID stringByAppendingString:@"/related-artists"]];
        [request setValue:header forHTTPHeaderField:@"Authorization"];
        [request setURL:idURL];
        
        NSMutableArray *relatedArtists = [[NSMutableArray alloc] init];

        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *artistIDTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable artistData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error != nil) {
                }
                else {
                    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:artistData options:0 error:nil];
                    NSMutableArray *fullArtistsArray = [[NSMutableArray alloc] init];
                    fullArtistsArray = [responseDict valueForKey:@"artists"];
                    for (int j = 0; j < fullArtistsArray.count; j ++) {
                        [relatedArtists addObject:responseDict[@"artists"][j][@"name"]];
                    }
                    [relatedDict setObject:relatedArtists forKey:artistID];
                    [self saveRelatedArtists];
                }
        }];
        [artistIDTask resume];
    }
}

- (void)saveRelatedArtists {
    if (relatedDict.count == 20) {
        NSArray *userArtistIDs = [[NSArray alloc] init];
        NSArray *relatedArtistsFullArray = [[NSArray alloc] init];
        userArtistIDs = [relatedDict allKeys];
        relatedArtistsFullArray = [relatedDict allValues];

        PFObject *relatedArtistObject = [PFObject objectWithClassName:@"RelatedArtists"];
        relatedArtistObject[@"artistId"] = userArtistIDs;
        relatedArtistObject[@"relatedArtists"] = relatedArtistsFullArray;
        relatedArtistObject[@"username"] = PFUser.currentUser.username;
        [relatedArtistObject saveInBackground];
        NSLog(@"saved related");
    }
}


@end
