//
//  RecentFromPlacesTVC.m
//  4_FlickerFetcher
//
//  Created by Zachary Fleischman on 3/1/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "RecentFromPlacesTVC.h"
#import "FlickrFetcher.h"
#import "PhotoScrollViewController.h"

@interface RecentFromPlacesTVC ()
@property NSArray *picturesData;
@end

@implementation RecentFromPlacesTVC
@synthesize picturesData = _picturesData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
    //use GCD to load data
    dispatch_queue_t downlaodQueue = dispatch_queue_create("data downloader", NULL);
    dispatch_async(downlaodQueue, ^{
        NSArray *photos = [FlickrFetcher photosInPlace:self.place maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picturesData = photos;
            [spinner stopAnimating];
        });
    });

    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Photo From Place"]) {
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
    static NSString *CellIdentifier = @"Top Place Picture Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSDictionary *picInfo = [self.picturesData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = @"Unknown";
    if([picInfo objectForKey:@"title"] != @"") cell.textLabel.text = [picInfo objectForKey:@"title"];
    
    cell.detailTextLabel.text = @"Unknown";
    if([picInfo valueForKeyPath:@"description._content"] != @"") cell.detailTextLabel.text = [picInfo valueForKeyPath:@"description._content"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedPic = [self.picturesData objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recent = [[defaults objectForKey:@"FlickrFetcherRecentPictures"] mutableCopy];
    
    //make sure it isn't already in there
    if(recent) {
        for(NSDictionary *pic in recent) {
            if([pic objectForKey:@"id"] == [selectedPic objectForKey:@"id"]) return;
        }
    }
    
    //create a new recent list with the selected one on top
    NSMutableArray *newRecent = [[NSMutableArray alloc] initWithObjects:selectedPic, nil];
    if(recent) {
        [newRecent addObjectsFromArray:recent];
    }
    
    //trim to only 20 pictures
    if(newRecent.count > 20) {
        [newRecent removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(20, (newRecent.count-20))]];
    }
    
    [defaults setObject:[newRecent copy] forKey:@"FlickrFetcherRecentPictures"];
}

@end
