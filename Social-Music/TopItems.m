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
                
                //fetch STID object and get photos + names
                
                NSString *trackURLString = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:@"tracks"];
                
                NSURL *trackURL = [NSURL URLWithString:trackURLString];
                [request setValue:header forHTTPHeaderField:@"Authorization"];
                [request setURL:trackURL];
                        
                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDataTask *trackTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable trackData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    NSDictionary *trackDict = [NSJSONSerialization JSONObjectWithData:trackData options:0 error:nil];
                    [SpotifyTopItemsData getResponseWithArtists:artistDict andTracks:trackDict withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    }];
                    
                    //fetch STID object and get photos + names
                }];
                [trackTask resume];
            }
        completion();
        }];
    [artistTask resume];
}

- (void) saveTopTracks {
    PFObject *topTracks = [PFObject objectWithClassName:@"Songs"];
    PFUser *curr = PFUser.currentUser;
    topTracks[@"user"] = curr;
    topTracks[@"username"] = curr.username;
    
    if (!([curr[@"statusSong"] isEqualToString:@"saved"])) {
        topTracks[@"data"] = self.trackData;
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
        topArtists[@"data"] = self.artistData;
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
