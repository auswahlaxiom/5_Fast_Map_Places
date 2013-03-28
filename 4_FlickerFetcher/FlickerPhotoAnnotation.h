//
//  FlickerPhotoAnnotation.h
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/27/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickerPhotoAnnotation : NSObject <MKAnnotation>
+(FlickerPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo;
@property (nonatomic, strong) NSDictionary *photo;

@end
