//
//  HomeViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "SongViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemotePlayerAPI.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTSession.h>
#import <SpotifyiOS/SpotifyAppRemote.h>

@interface SongViewController ()

@end

@implementation SongViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapSkip:(id)sender {
    
    /*[self.appRemote.playerAPI skipToNext:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"failed");
        } else {
            NSLog(@"success");
        }
    }];*/
    
}

- (IBAction)didTapSpotify:(id)sender {
}


@end
