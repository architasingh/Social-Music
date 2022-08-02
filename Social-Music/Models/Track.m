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

+ (Track *) getTrack:(NSString *)name image:(NSString*)imageString {
    // get UIImage
    NSURL *url = [NSURL URLWithString:imageString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    // create a track with name and image props
    Track *track = [[Track alloc] initWithName:name image:image];
    return track;
}

+ (NSMutableArray *)buildArrayofTracks: (NSArray *)arrayName withPhotos : (NSArray *)arrayPhoto  {
    NSMutableArray *arrayOfTracks = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayName.count; i++) {
        Track *track = [Track getTrack:arrayName[i] image:arrayPhoto[i]];
        [arrayOfTracks addObject:track];
    }
    return arrayOfTracks;
}

@end
