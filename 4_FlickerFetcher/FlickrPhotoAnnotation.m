//
//  FlickerPhotoAnnotation.m
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/27/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
// herpa derpa derp derp

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoAnnotation
@synthesize photo = _photo;
+(FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo {
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

-(NSString *)title {
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}
-(NSString *)subtitle {
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}
-(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:@"latitude"] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:@"longitude"] doubleValue];
    return coordinate;
}

@end
