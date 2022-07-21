//
//  TopItems.h
//  Social-Music
//
//  Created by Archita Singh on 7/21/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopItems : NSObject

+ (id)shared;
- (void)fetchTopData:(NSString *)type;

@property (nonatomic, strong) NSArray *artistData;
@property (nonatomic, strong) NSArray *trackData;

@end

NS_ASSUME_NONNULL_END
