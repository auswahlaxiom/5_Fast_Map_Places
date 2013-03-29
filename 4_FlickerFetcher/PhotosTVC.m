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
#import "FlickrMapViewController.h"
#import "FlickrPhotoAnnotation.h"
#import "PhotoScrollViewController.h"

@interface PhotosTVC ()
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
    }
}
- (NSArray *)picturesData {
    return _picturesData;
}
-(NSArray *)mapAnnotations {
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.picturesData count]];
    for(NSDictionary *dict in self.picturesData) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:dict]];
    }
    return annotations;
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
    } else if([[segue identifier] isEqualToString:@"View Map"]) {
        FlickrMapViewController *dest = segue.destinationViewController;
        dest.annotations = [self mapAnnotations];
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
    char* threadName = "image downloader" + indexPath.section + indexPath.row;
    
    dispatch_queue_t downlaodQueue = dispatch_queue_create(threadName, NULL);
    dispatch_async(downlaodQueue, ^{
        NSURL *photoURL = [FlickrFetcher urlForPhoto:picInfo format:FlickrPhotoFormatSquare];
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        UIImage *photoImage = [UIImage imageWithData:photoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = photoImage;
        });
    });

    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id detail = [self.splitViewController.viewControllers lastObject];
    if([detail isKindOfClass:[PhotoScrollViewController class]]) {
        PhotoScrollViewController *photoVC = detail;
        NSDictionary *photo = [self.picturesData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        photoVC.photo = photo;
        if([photo objectForKey:@"title"] != @"") {
            photoVC.navigationItem.title =[photo objectForKey:@"title"];
        } else {
            photoVC.navigationItem.title = @"Unknown";
        }
        [photoVC viewDidLoad];
    }
}


@end
