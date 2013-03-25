//
//  PhotoScrollViewController.m
//  4_FlickerFetcher
//
//  Created by Zachary Fleischman on 3/2/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "PhotoScrollViewController.h"
#import "FlickrFetcher.h"

@interface PhotoScrollViewController () <UIScrollViewDelegate>

@end

@implementation PhotoScrollViewController
@synthesize scrollView;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //make spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
    //use GCD to load image
    dispatch_queue_t downlaodQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downlaodQueue, ^{
        NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatOriginal];
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        UIImage *photoImage = [UIImage imageWithData:photoData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = photoImage;
            if(photoImage) {
                self.scrollView.contentSize = self.imageView.image.size;
                self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
                
                CGFloat vScale = self.scrollView.frame.size.height / self.imageView.image.size.height;
                CGFloat hScale = self.scrollView.frame.size.width / self.imageView.image.size.width;
                
                //adjust min/max zoom scales for image if neccessary
                if(MIN(vScale, hScale) < self.scrollView.minimumZoomScale) self.scrollView.minimumZoomScale = MIN(vScale, hScale);
                if(MAX(vScale, hScale) > self.scrollView.maximumZoomScale) self.scrollView.maximumZoomScale = MAX(vScale, hScale);
                
                //initial zoom state such that there are no blank bars, and the image is as big as possible while still all fitting in
                if(vScale < hScale) {
                    [self.scrollView setZoomScale:hScale animated:YES];
                } else {
                    [self.scrollView setZoomScale:vScale animated:YES];
                }
            }
            [spinner stopAnimating];
        });
    });
    //dispatch_release(downlaodQueue);

}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


@end
