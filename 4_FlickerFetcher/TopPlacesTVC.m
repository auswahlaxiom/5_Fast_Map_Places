//
//  TopPlacesTVC.m
//  4_FlickerFetcher
//
//  Created by Zachary Fleischman on 2/28/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "FlickrFetcher.h"
#import "PhotosFromPlaceTVC.h"
#import "FlickrMapViewController.h"
#import "FlickrPlaceAnnotation.h"

@interface TopPlacesTVC ()
@property NSArray *topPlaceData;
@end

@implementation TopPlacesTVC

@synthesize topPlaceData = _topPlaceData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *oldButton = self.navigationItem.rightBarButtonItem;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"_content" ascending:YES];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
    //use GCD to load data
    dispatch_queue_t downlaodQueue = dispatch_queue_create("data downloader", NULL);
    dispatch_async(downlaodQueue, ^{
        NSArray *places = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.topPlaceData = places;
            [spinner stopAnimating];
            self.navigationItem.rightBarButtonItem = oldButton;
        });
    });
}

- (void)setTopPlaceData:(NSArray *)data {
    if(_topPlaceData != data) {
        _topPlaceData = data;
        if(self.tableView.window) [self.tableView reloadData];
    }
}
- (NSArray *)topPlaceData {
    return _topPlaceData;
}

-(NSArray *)mapAnnotations {
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.topPlaceData count]];
    for(NSDictionary *dict in self.topPlaceData) {
        [annotations addObject:[FlickrPlaceAnnotation annotationForPlace:dict]];
    }
    return annotations;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Photos From Place"]) {
        PhotosFromPlaceTVC *dest = segue.destinationViewController;
        
        //selectedPlace is set when a cell is selected
        NSDictionary *place = [self.topPlaceData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        dest.place = place;
        dest.navigationItem.title = [[[place objectForKey:@"_content"] componentsSeparatedByString:@", "] objectAtIndex:0];
        
    } else if([[segue identifier] isEqualToString:@"View Map"]) {
        FlickrMapViewController *dest = segue.destinationViewController;
        dest.navigationItem.title = @"Top Places";
        dest.annotations = [self mapAnnotations];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topPlaceData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSString *place = [[self.topPlaceData objectAtIndex:indexPath.row] objectForKey:@"_content"];
    
    NSArray *placeParts = [place componentsSeparatedByString:@", "];
    
    cell.textLabel.text = [placeParts objectAtIndex:0];
    
    cell.detailTextLabel.text = [placeParts objectAtIndex:1];
    
    for(int i = 2; i < placeParts.count; i++) {
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@", %@", [placeParts objectAtIndex:i]];
    }
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
