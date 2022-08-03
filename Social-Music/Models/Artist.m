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

// Load artist image
// Create artist with name and image properties
+ (Artist *) getArtist:(NSString *)name image:(NSString*)imageString {
    NSURL *url = [NSURL URLWithString:imageString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    Artist *artist = [[Artist alloc] initWithName:name image:image];
    return artist;
}

// Make an array of artists given an array of names and an array of photos
+ (NSMutableArray *)buildArrayofArtists: (NSArray *)arrayName withPhotos : (NSArray *)arrayPhoto  {
    NSMutableArray *arrayOfArtists = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayName.count; i++) {
        Artist *artist = [Artist getArtist:arrayName[i] image:arrayPhoto[i]];
        [arrayOfArtists addObject:artist];
    }
    return arrayOfArtists;
}


@end
