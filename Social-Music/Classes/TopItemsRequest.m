//
//  TopItemsRequest.m
//  Social-Music
//
//  Created by Archita Singh on 8/3/22.
//

#import "TopItemsRequest.h"
#import "SpotifyManager.h"
#import "SpotifyTopItemsData.h"

@implementation TopItemsRequest

- (id)init {
    if ((self = [super init]) ) {
        [self fetchTopDataWithCompletion:^{
        }];
    }
    return self;
}

// Fetch top artists and tracks from Spotify Web API
- (void)fetchTopDataWithCompletion: (void(^)(void)) completion {
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
                
                NSString *trackURLString = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:@"tracks"];
                
                NSURL *trackURL = [NSURL URLWithString:trackURLString];
                [request setValue:header forHTTPHeaderField:@"Authorization"];
                [request setURL:trackURL];
                        
                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDataTask *trackTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable trackData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    NSDictionary *trackDict = [NSJSONSerialization JSONObjectWithData:trackData options:0 error:nil];
                    
                    [SpotifyTopItemsData getResponseWithArtists:artistDict andTracks:trackDict withCompletion:^{
                        completion();
                    }];
                }];
                [trackTask resume];
            }
        }];
    [artistTask resume];
}

@end
