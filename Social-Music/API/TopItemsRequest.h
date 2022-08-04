//
//  TopItemsRequest.h
//  Social-Music
//
//  Created by Archita Singh on 8/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopItemsRequest : NSObject

- (void)fetchTopDataOfType: (NSString *)type WithCompletion: (void(^)(void)) completion;

@end

NS_ASSUME_NONNULL_END
