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
    self.artistPhotos = [[NSMutableArray alloc] init];
    self.trackPhotos = [[NSMutableArray alloc] init];
    
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
                    for (int i = 0; i < 20; i++) {
                        [self.artistData addObject:dataDictionary[@"items"][i][@"name"]];
                        [self.artistPhotos addObject:dataDictionary[@"items"][i][@"images"][0][@"url"]];
                       
                    }
                    
                    NSLog(@"artist data: %@", self.artistData);
                    completion();
                    [self saveTopArtists];
                    return;
                } if ([type  isEqual: @"tracks"]) {
                    for (int i = 0; i < 20; i++) {
                        [self.trackData addObject:dataDictionary[@"items"][i][@"name"]];
                        [self.trackPhotos addObject:dataDictionary[@"items"][i][@"album"][@"images"][0][@"url"]];
                    }
                    NSLog(@"track data: %@", self.trackData);
                    completion();
                    [self saveTopSongs];
                }
            }
        }];
    [task resume];
}

- (void) saveTopSongs {
    PFObject *topSongs = [PFObject objectWithClassName:@"Songs"];
    PFUser *curr = PFUser.currentUser;
    topSongs[@"user"] = curr;
    topSongs[@"username"] = curr.username;
    
    if (!([curr[@"statusSong"] isEqualToString:@"saved"])) {
        topSongs[@"text"] = self.trackData;
        topSongs[@"songImage"] = self.trackPhotos;
        
        [topSongs saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    if (self.trackData != nil) {
                        curr[@"statusSong"] = @"saved";
                        curr[@"topSongs"] = topSongs;
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
        topArtists[@"artistImage"] = self.artistPhotos;
    
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
