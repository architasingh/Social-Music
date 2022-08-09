//
//  KeysManager.m
//  Social-Music
//
//  Created by Archita Singh on 8/2/22.
//

#import "KeysManager.h"

@implementation KeysManager
NSDictionary* dict;

- (id)init {
    if ((self = [super init]) ) {
        dict = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"]];
    }
    return self;
}

// Extract Parse and Spotify keys from plist to be used across view controllers
- (NSString *)getSpotifyClientID {
    return [dict objectForKey: @"client_key"];
}

- (NSString *)getParseAppID {
    return [dict objectForKey: @"parse_app_id"];
}

- (NSString *)getParseClientKey {
    return [dict objectForKey: @"parse_client_key"];
}

@end
