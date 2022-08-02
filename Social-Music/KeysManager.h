//
//  KeysManager.h
//  Social-Music
//
//  Created by Archita Singh on 8/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeysManager : NSObject

+ (id)shared;

- (void)getKeys;

@property (nonatomic, strong) NSString * spotifyClientID;
@property (nonatomic, strong) NSString * parseClientKey;
@property (nonatomic, strong) NSString * parseAppID;

@end

NS_ASSUME_NONNULL_END
