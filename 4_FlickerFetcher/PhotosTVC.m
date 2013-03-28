//
//  PhotosTVCViewController.m
//  5_Fast_Map_Places
//
//  Created by Zachary Fleischman on 3/27/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "PhotosTVC.h"

#import "FlickrFetcher.h"
#import "PhotoScrollViewController.h"
#import "MapViewController.h"
#import "FlickerPhotoAnnotation.h"
@interface PhotosTVC () <MapViewControllerDelegate>
@end

@implementation PhotosTVC
@synthesize picturesData = _picturesData;

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setPicturesData:(NSArray *)data {
    if(_picturesData != data) {
        _picturesData = data;
        if(self.tableView.window) [self.tableView reloadData];
        [self updateSplitViewDetail];
    }
}
- (NSArray *)picturesData {
    return _picturesData;
}
-(NSArray *)mapAnnotations {
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.picturesData count]];
    for(NSDictionary *dict in self.picturesData) {
        [annotations addObject:[FlickerPhotoAnnotation annotationForPhoto:dict]];
    }
    return annotations;
}
-(void) updateSplitViewDetail {
    id detail = [self.splitViewController.viewControllers lastObject];
    if([detail isKindOfClass:[MapViewController class]]) {
        MapViewController *mapVC = (MapViewController *)detail;
        mapVC.annotations = [self mapAnnotations];
        mapVC.delegate = self;
    }
}
-(UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation {
    FlickerPhotoAnnotation *fpa = (FlickerPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Photo"]) {
        PhotoScrollViewController *dest = segue.destinationViewController;
        NSDictionary *photo = [self.picturesData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        dest.photo = photo;
        if([photo objectForKey:@"title"] != @"") {
            dest.navigationItem.title =[photo objectForKey:@"title"];
        } else {
            dest.navigationItem.title = @"Unknown";
        }
        
    }
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.picturesData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSDictionary *picInfo = [self.picturesData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = @"Unknown";
    if([picInfo objectForKey:@"title"]) cell.textLabel.text = [picInfo objectForKey:@"title"];
    
    cell.detailTextLabel.text = @"Unknown";
    if([picInfo valueForKeyPath:@"description._content"]) cell.detailTextLabel.text = [picInfo valueForKeyPath:@"description._content"];
    
    
    return cell;
}

@end
