//
//  MapViewController.m
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/27/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "FlickrMapViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoAnnotation.h"
#import <MapKit/MapKit.h>

@interface FlickrMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation FlickrMapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;

-(void)viewWillAppear:(BOOL)animated {
    [self zoomToFitMapAnnotations:self.mapView];
}
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
    if(self.mapView.window) [self zoomToFitMapAnnotations:self.mapView];
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
    if([view.annotation isKindOfClass:[FlickrPhotoAnnotation class]]) {
        FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)view.annotation;
        
         dispatch_queue_t downlaodQueue = dispatch_queue_create("image downloader", NULL);
         dispatch_async(downlaodQueue, ^{
             NSURL *photoURL = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
             NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
             UIImage *photoImage = [UIImage imageWithData:photoData];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [(UIImageView *)view.leftCalloutAccessoryView setImage:photoImage];
             });
         });
         
    }
}
-(void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    //return;
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    if(region.span.latitudeDelta > 360) region.span.latitudeDelta = 360;
    if(region.span.longitudeDelta > 180) region.span.longitudeDelta = 180;

    [mapView setRegion:region animated:YES];
}
-(BOOL)shouldAutorotate{
    return YES;
}

@end
