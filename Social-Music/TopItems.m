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

- (void)fetchTopData:(NSString *)type completion: (void(^)(void)) completion {
    self.artistData = [[NSMutableArray alloc] init];
    self.trackData = [[NSMutableArray alloc] init];
//    self.artistPhotos = [[NSMutableArray alloc] init];
//    self.trackPhotos = [[NSMutableArray alloc] init];
    
    NSString *token = [[SpotifyManager shared] accessToken];
    
    NSString *tokenType = @"Bearer";
    NSString *header = [NSString stringWithFormat:@"%@ %@", tokenType, token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *baseURL = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:type];
    NSURL *url = [NSURL URLWithString:baseURL];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setURL:url];
            
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                if ([type  isEqual: @"artists"]) {
                    [SpotifyTopItemsData getResponseWithData:dataDictionary ofType:@"artists" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    }];
                }
                if ([type  isEqual: @"tracks"]) {
                    [SpotifyTopItemsData getResponseWithData:dataDictionary ofType:@"tracks" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    }];
                }
                //this part now in spotify top items data
                /*NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([type  isEqual: @"artists"]) {
                    for (int i = 0; i < 20; i++) {
                        NSString *artistName = dataDictionary[@"items"][i][@"name"];
                        NSString *artistPhoto = dataDictionary[@"items"][i][@"images"][0][@"url"];
                        
                        Artist *artist = [Artist getArtist:artistName image:artistPhoto withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                        }];
                        
                        [self.artistData addObject:artist];
                        
//                        [self.artistData addObject:dataDictionary[@"items"][i][@"name"]];
//                        [self.artistPhotos addObject:dataDictionary[@"items"][i][@"images"][0][@"url"]];
                       
                    }
                    
                    NSLog(@"artist data: %@", self.artistData);
                    completion();
//                    [self saveTopArtists];
                    return;
                } if ([type  isEqual: @"tracks"]) {
                    for (int i = 0; i < 20; i++) {
                        
                        NSString *trackName = dataDictionary[@"items"][i][@"name"];
                        NSString *trackPhoto = dataDictionary[@"items"][i][@"album"][@"images"][0][@"url"];
                        
                        Track *track = [Track getTrack:trackName image:trackPhoto withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                        }];
                        
                        [self.trackData addObject:track];
                        
//                        [self.trackData addObject:dataDictionary[@"items"][i][@"name"]];
//                        [self.trackPhotos addObject:dataDictionary[@"items"][i][@"album"][@"images"][0][@"url"]];
                    }
                    NSLog(@"track data: %@", self.trackData);
                    completion();
//                    [self saveTopTracks];
                }*/
            }
        }];
    [task resume];
}

- (void) saveTopTracks {
    PFObject *topTracks = [PFObject objectWithClassName:@"Songs"];
    PFUser *curr = PFUser.currentUser;
    topTracks[@"user"] = curr;
    topTracks[@"username"] = curr.username;
    
    if (!([curr[@"statusSong"] isEqualToString:@"saved"])) {
        topTracks[@"text"] = self.trackData;
//        topTracks[@"songImage"] = self.trackPhotos;
        
        [topTracks saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    if (self.trackData != nil) {
                        curr[@"statusSong"] = @"saved";
                        curr[@"topSongs"] = topTracks;
                        [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            NSLog(@"The song data was saved!");
                        }];
                    }
                } else {
                    NSLog(@"Problem saving song data: %@", error.localizedDescription);
                }
            }];
    }
}

- (void) saveTopArtists {
    PFObject *topArtists = [PFObject objectWithClassName:@"Artists"];
    PFUser *curr = PFUser.currentUser;
    topArtists[@"user"] = curr;
    topArtists[@"username"] = curr.username;
   
    if (!([curr[@"statusArtist"] isEqualToString:@"saved"])) {
        topArtists[@"text"] = self.artistData;
//        topArtists[@"artistImage"] = self.artistPhotos;
    
        [topArtists saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    if(topArtists != nil) {
                        curr[@"statusArtist"] = @"saved";
                        curr[@"topArtists"] = topArtists;
                        [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            NSLog(@"The artist data was saved!");
                        }];
                    }
                } else {
                    NSLog(@"Problem saving artist data: %@", error.localizedDescription);
                }
            }];
    }
}

@end
