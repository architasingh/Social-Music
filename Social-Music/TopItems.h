//
//  TopItems.h
//  Social-Music
//
//  Created by Archita Singh on 7/21/22.
//

#import "Track.h"
#import "Artist.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopItems : NSObject

+ (id)shared;

- (void)fetchTopDataWithCompletion: (void(^)(void)) completion;

@end

NS_ASSUME_NONNULL_END
