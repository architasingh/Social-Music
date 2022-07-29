//
//  Track.h
//  Social-Music
//
//  Created by Archita Singh on 7/27/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Track : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *photo;

- (instancetype)initWithName: (NSString *)name image: (UIImage *)photo;
+ (Track *) getTrack:(NSString *)name image:(NSString*)imageString;
+ (NSMutableArray *)buildArrayofTracks: (NSArray *)arrayName withPhotos : (NSArray *)arrayPhoto;

@end

NS_ASSUME_NONNULL_END
