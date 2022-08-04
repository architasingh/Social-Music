//
//  KeysManager.h
//  Social-Music
//
//  Created by Archita Singh on 8/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeysManager : NSObject

- (NSString *)getSpotifyClientID;
- (NSString *)getParseAppID;
- (NSString *)getParseClientKey;

@end

NS_ASSUME_NONNULL_END
