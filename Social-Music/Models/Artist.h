//
//  Artist.h
//  Social-Music
//
//  Created by Archita Singh on 7/27/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Artist : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *photo;

- (instancetype)initWithName: (NSString *)name image: (UIImage *)photo;
+ (Artist *) getArtist:(NSString *)name image:(NSString*)imageString withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
