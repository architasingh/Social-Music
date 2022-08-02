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

+ (Artist *) getArtist:(NSString *)name image:(NSString*)imageString {
    // get UIImage
    NSURL *url = [NSURL URLWithString:imageString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    // create a track with name and image props
    Artist *artist = [[Artist alloc] initWithName:name image:image];
    return artist;
}

+ (NSMutableArray *)buildArrayofArtists: (NSArray *)arrayName withPhotos : (NSArray *)arrayPhoto  {
    NSMutableArray *arrayOfArtists = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayName.count; i++) {
        Artist *artist = [Artist getArtist:arrayName[i] image:arrayPhoto[i]];
        [arrayOfArtists addObject:artist];
    }
    return arrayOfArtists;
}


@end
