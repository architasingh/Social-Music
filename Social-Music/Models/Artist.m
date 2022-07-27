//
//  Artist.m
//  Social-Music
//
//  Created by Archita Singh on 7/27/22.
//

#import "Artist.h"

@implementation Artist

- (instancetype)initWithName: (NSString *)name image: (UIImage *)photo {
    self = [super init];
    if (self) {
        self.name = name;
        self.photo = photo;
    }
   
    return self;
}

+ (Artist *) getArtist:(NSString *)name image:(NSString*)imageString withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    // get UIImage
    NSURL *url = [NSURL URLWithString:imageString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    // create a track with name and image props
    Artist *artist = [[Artist alloc] initWithName:name image:image];
    return artist;
}
@end
