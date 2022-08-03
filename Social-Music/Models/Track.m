//
//  Track.m
//  Social-Music
//
//  Created by Archita Singh on 7/27/22.
//

#import "Track.h"

@implementation Track

- (instancetype)initWithName: (NSString *)name image: (UIImage *)photo {
    self = [super init];
    if (self) {
        self.name = name;
        self.photo = photo;
    }
    return self;
}

// Load track image
// Create track with name and image properties
+ (Track *) getTrack:(NSString *)name image:(NSString*)imageString {
    NSURL *url = [NSURL URLWithString:imageString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    Track *track = [[Track alloc] initWithName:name image:image];
    return track;
}

// Make an array of tracks given an array of names and an array of photos
+ (NSMutableArray *)buildArrayofTracks: (NSArray *)arrayName withPhotos : (NSArray *)arrayPhoto  {
    NSMutableArray *arrayOfTracks = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayName.count; i++) {
        Track *track = [Track getTrack:arrayName[i] image:arrayPhoto[i]];
        [arrayOfTracks addObject:track];
    }
    return arrayOfTracks;
}

@end
