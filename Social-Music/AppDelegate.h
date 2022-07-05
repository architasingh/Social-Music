//
//  AppDelegate.h
//  Social-Music
//
//  Created by Archita Singh on 7/3/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SPTSessionManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTSessionManagerDelegate>

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;

@end

