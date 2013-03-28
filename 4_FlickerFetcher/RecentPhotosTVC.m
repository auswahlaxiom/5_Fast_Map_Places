//
//  RecentPlacesTVC.m
//  4_FlickerFetcher
//
//  Created by Zachary Fleischman on 2/28/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "RecentPhotosTVC.h"
#import "Flickrfetcher.h"
#import "PhotoScrollViewController.h"
#import "MapViewController.h"
#import "FlickerPhotoAnnotation.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.picturesData = [defaults objectForKey:@"FlickrFetcherRecentPictures"];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.picturesData = [defaults objectForKey:@"FlickrFetcherRecentPictures"];
    [self.tableView reloadData];
}


@end
