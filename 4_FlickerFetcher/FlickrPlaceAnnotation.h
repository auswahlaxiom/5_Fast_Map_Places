//
//  FlickrPlaceAnnotation.h
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/28/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>
+(FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place;
@property (strong, nonatomic)NSDictionary *place;
@end
