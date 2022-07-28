//
//  TopItems.m
//  Social-Music
//
//  Created by Archita Singh on 7/21/22.
//

#import "TopItems.h"
#import <Parse/Parse.h>
#import "SpotifyManager.h"
#import "Parse/PFImageView.h"
#import "SpotifyTopItemsData.h"

@implementation TopItems
+ (id)shared {
    static TopItems *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)fetchTopDataWithCompletion: (void(^)(void)) completion {
    
    self.artistData = [[NSMutableArray alloc] init];
    self.trackData = [[NSMutableArray alloc] init];

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
                    
                    for (int i = 0; i < 20; i++) {
                        NSString *trackName = trackDict[@"items"][i][@"name"];
                        NSString *trackPhoto = trackDict[@"items"][i][@"album"][@"images"][0][@"url"];

                        Track *track = [Track getTrack:trackName image:trackPhoto withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                        }];

                        [self.trackData addObject:track];

                        NSString *artistName = artistDict[@"items"][i][@"name"];
                        NSString *artistPhoto = artistDict[@"items"][i][@"images"][0][@"url"];

                        Artist *artist = [Artist getArtist:artistName image:artistPhoto withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                                                }];

                        [self.artistData addObject:artist];
                    }
                    NSLog(@"artist data %@", self.artistData);
                    NSLog(@"track data %@", self.trackData);
                    
                    [SpotifyTopItemsData getResponseWithArtists:artistDict andTracks:trackDict withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    }];
                }];
                [trackTask resume];
            }
        completion();
        }];
    [artistTask resume];
}

@end
