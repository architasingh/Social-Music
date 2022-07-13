//
//  SceneDelegate.h
//  Social-Music
//
//  Created by Archita Singh on 7/3/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SPTSessionManager.h>
#import <SpotifyiOS/SPTAppRemote.h>
#import <SpotifyiOS/SPTConfiguration.h>

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) SPTAppRemote *appRemote;

@end

