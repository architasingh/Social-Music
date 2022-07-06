//
//  AppDelegate.m
//  Social-Music
//
//  Created by Archita Singh on 7/3/22.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <SpotifyiOS/SPTConfiguration.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTAppRemotePlayerState.h>

@interface AppDelegate () <SPTAppRemotePlayerStateDelegate>

@property(nonatomic, strong) LoginViewController *rootViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [LoginViewController new];
    self.rootViewController = [LoginViewController new];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    NSString *SpotifyClientID = [dict objectForKey: @"client_key"];
    
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
                                                                          redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
    /* The session manager lets you authorize, get access tokens, and so on. */
    configuration.playURI = @"spotify:track:20I6sIOMTCkB6w7ryavxtO";
    
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration
                                                                        delegate:self];
    
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:configuration logLevel:SPTAppRemoteLogLevelDebug];
    
    self.appRemote.delegate = self;

    SPTScope requestedScope = SPTAppRemoteControlScope;
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    
    return YES;
    
    /*NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSString *spotifyClientID = [dict objectForKey: @"client_key"];
    NSString *spotifyClientIDSecret = [dict objectForKey: @"client_secret"];
    
    NSURL *spotifyRedirectURL = [NSURL URLWithString:@"spotify-ios-quick-start://spotify-login-callback"];
    
    self.configuration = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];
   
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
    
    self.appRemote.delegate = self;

    SPTScope requestedScope = SPTAppRemoteControlScope;
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    
    return self;*/
}

/* - (void) parseBackend {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

            configuration.applicationId = @"4rFA5IOfLkZUPvBK3cBl5vfxsNWDGwcoFPFq5rpO";
            configuration.clientKey = @"ZcaO0xmXqxj91dL4Ma6QDEFLEiHl1PKe1oA9YPgE";
            configuration.server = @"https://parseapi.back4app.com";
        }];

        [Parse initializeWithConfiguration:config];
} */

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self.rootViewController.sessionManager application:app openURL:url options:options];
       NSLog(@"%@ %@", url, options);
       return YES;
    /*[self.sessionManager application:app openURL:url options:options];
    return true;*/
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)appRemote {
    self.appRemote.playerAPI.delegate = self;
     [self.appRemote.playerAPI subscribeToPlayerState:^(id _Nullable result, NSError * _Nullable error) {
       if (error) {
         NSLog(@"error: %@", error.localizedDescription);
       }
     }];
    NSLog(@"connected");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"disconnected");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"failed");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  if (self.appRemote.isConnected) {
    [self.appRemote disconnect];
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  if (self.appRemote.connectionParameters.accessToken) {
    [self.appRemote connect];
  }
}

@end
