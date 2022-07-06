//
//  HomeViewController.m
//  Social-Music
//
//  Created by Archita Singh on 7/6/22.
//

#import "LoginViewController.h"
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTSessionManager.h>

//static NSString * const SpotifyClientID = @"<#ClientID#>";
static NSString * const SpotifyRedirectURLString = @"spotify-ios-quick-start://spotify-login-callback";

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)didTapLogin:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    /*NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    NSString *SpotifyClientID = [dict objectForKey: @"client_key"];
    
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
                                                                          redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
  
    configuration.playURI = @"spotify:track:20I6sIOMTCkB6w7ryavxtO";
    
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration
                                                                        delegate:self];*/

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapLogin:(id)sender {
    SPTScope scope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;

        /*
         Start the authorization process. This requires user input.
         */
        if (@available(iOS 11, *)) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
            [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption presentingViewController:self];
        }
}

- (void)sessionManager:(nonnull SPTSessionManager *)manager didInitiateSession:(nonnull SPTSession *)session {
    self.appRemote.connectionParameters.accessToken = session.accessToken;
    [self.appRemote connect];
    NSLog(@"success: %@", session);

}

- (void)sessionManager:(nonnull SPTSessionManager *)manager didFailWithError:(nonnull NSError *)error {
    NSLog(@"fail: %@", error);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(nonnull SPTSession *)session
{
  NSLog(@"renewed: %@", session);
}

- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    NSLog(@"Track name: %@", playerState.track.name);
    NSLog(@"player state changed");
}

@end
