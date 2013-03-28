//
//  MapViewController.m
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/27/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

-(void)setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    [self updateMapView];
}
-(void)setAnnotations:(NSArray *)annotations {
    _annotations = annotations;
    [self updateMapView];
}
-(void)updateMapView {
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.annotations];
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if(!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:view.annotation];
    [(UIImageView *)view.leftCalloutAccessoryView setImage:image];

}
-(BOOL)shouldAutorotate{
    return YES;
}

@end
