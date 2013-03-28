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

@interface TopPlacesTVC ()
@property NSArray *topData;
@end

@implementation TopPlacesTVC

@synthesize topData = _topData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)refresh:(UIBarButtonItem *)sender {
    [self viewDidLoad];
}

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
            self.topData = places;
            [spinner stopAnimating];
            self.navigationItem.rightBarButtonItem = oldButton;
        });
    });
}

- (void)setTopData:(NSArray *)data {
    if(_topData != data) {
        _topData = data;
        if(self.tableView.window) [self.tableView reloadData];
    }
}
- (NSArray *)topData {
    return _topData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Photos From Place"]) {
        PhotosFromPlaceTVC *dest = segue.destinationViewController;
        
        //selectedPlace is set when a cell is selected
        NSDictionary *place = [self.topData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        dest.place = place;
        dest.navigationItem.title = [[[place objectForKey:@"_content"] componentsSeparatedByString:@", "] objectAtIndex:0];
        
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSString *place = [[self.topData objectAtIndex:indexPath.row] objectForKey:@"_content"];
    
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
