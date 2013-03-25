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

@interface RecentPhotosTVC ()
@property NSArray *picturesData;
@end

@implementation RecentPhotosTVC
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.picturesData = [defaults objectForKey:@"FlickrFetcherRecentPictures"];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.picturesData = [defaults objectForKey:@"FlickrFetcherRecentPictures"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Photo From Recent"]) {
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
    static NSString *CellIdentifier = @"Recent Picture Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSDictionary *picInfo = [self.picturesData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = @"Unknown";
    if([picInfo objectForKey:@"title"]) cell.textLabel.text = [picInfo objectForKey:@"title"];
    
    cell.detailTextLabel.text = @"Unknown";
    if([picInfo valueForKeyPath:@"description._content"]) cell.detailTextLabel.text = [picInfo valueForKeyPath:@"description._content"];

    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
