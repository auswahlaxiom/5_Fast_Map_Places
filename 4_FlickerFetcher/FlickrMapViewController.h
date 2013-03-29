//
//  MapViewController.h
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/27/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FlickrMapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) NSArray *annotations;
@end
