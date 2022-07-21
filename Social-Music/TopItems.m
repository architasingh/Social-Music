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

- (void)fetchTopData:(NSString *)type {
    NSString *token = [[SpotifyManager shared] accessToken];;
    
    NSString *tokenType = @"Bearer";
    NSString *header = [NSString stringWithFormat:@"%@ %@", tokenType, token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *baseURL = [@"https://api.spotify.com/v1/me/top/" stringByAppendingString:type];
    NSURL *url = [NSURL URLWithString:baseURL];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setURL:url];
            
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([type  isEqual: @"artists"]) {
                    self.artistData = dataDictionary[@"items"];
                    [self saveTopArtists];
                } if ([type  isEqual: @"tracks"]) {
                    self.trackData = dataDictionary[@"items"];
                    [self saveTopSongs];
                }
            }
        }] resume];
}

- (void) saveTopSongs {
    PFObject *topSongs = [PFObject objectWithClassName:@"Songs"];
    PFUser *curr = PFUser.currentUser;
    topSongs[@"user"] = curr;
    topSongs[@"username"] = curr.username;
    
    if (!([curr[@"statusSong"] isEqualToString:@"saved"])) {
        NSMutableArray *topSongsArray = [NSMutableArray new];
        for (int i = 0; i < self.trackData.count; i++) {
            [topSongsArray addObject:self.trackData[i][@"name"]];
        }
//        NSLog(@"top songs: %@", topSongsArray);
        topSongs[@"text"] = topSongsArray;
        [topSongs saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    curr[@"statusSong"] = @"saved";
                    curr[@"topSongs"] = topSongs;
                    [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    }];
                    NSLog(@"The song data was saved!");
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
        NSMutableArray *topArtistsArray = [NSMutableArray new];
        for (int i = 0; i < self.artistData.count; i++) {
            [topArtistsArray addObject:self.artistData[i][@"name"]];
        }
//        NSLog(@"top artists: %@", topArtistsArray);
        topArtists[@"text"] = topArtistsArray;
    
        [topArtists saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    curr[@"statusArtist"] = @"saved";
                    curr[@"topArtists"] = topArtists;
                    [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    }];
                    NSLog(@"The artist data was saved!");
                } else {
                    NSLog(@"Problem saving artist data: %@", error.localizedDescription);
                }
            }];
    }
}

@end
