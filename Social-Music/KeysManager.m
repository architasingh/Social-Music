//
//  KeysManager.m
//  Social-Music
//
//  Created by Archita Singh on 8/2/22.
//

#import "KeysManager.h"

@implementation KeysManager
+ (id)shared {
    static KeysManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    if ((self = [super init]) ) {
        [self getKeys];
    }
    return self;
}

- (void)getKeys {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        
    self.spotifyClientID = [dict objectForKey: @"client_key"];
    self.parseAppID = [dict objectForKey: @"parse_app_id"];
    self.parseClientKey = [dict objectForKey: @"parse_client_key"];
}

@end
