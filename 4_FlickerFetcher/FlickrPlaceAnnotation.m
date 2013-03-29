//
//  FlickrPlaceAnnotation.m
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/28/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "FlickrPlaceAnnotation.h"

@implementation FlickrPlaceAnnotation

@synthesize place = _place;

+(FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place {
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
    annotation.place = place;
    return annotation;
}


-(NSString *)title {
    NSArray *placeParts = [[self.place objectForKey:@"_content"] componentsSeparatedByString:@", "];
    
    return [placeParts objectAtIndex:0];

    }
-(NSString *)subtitle {
    NSArray *placeParts = [[self.place objectForKey:@"_content"] componentsSeparatedByString:@", "];

    NSString *subtitle = [placeParts objectAtIndex:1];
    
    for(int i = 2; i < placeParts.count; i++) {
        subtitle = [subtitle stringByAppendingFormat:@", %@", [placeParts objectAtIndex:i]];
    }
    return subtitle;
}
-(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:@"latitude"] doubleValue];
    coordinate.longitude = [[self.place objectForKey:@"longitude"] doubleValue];
    return coordinate;
}
@end
