//
//  FlickerPhotoAnnotation.m
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/27/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "FlickerPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickerPhotoAnnotation
@synthesize photo = _photo;
+(FlickerPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo {
    FlickerPhotoAnnotation *annotation = [[FlickerPhotoAnnotation alloc] init];
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
