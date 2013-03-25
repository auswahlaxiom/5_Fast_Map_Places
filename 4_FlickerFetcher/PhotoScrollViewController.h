//
//  PhotoScrollViewController.h
//  4_FlickerFetcher
//
//  Created by Zachary Fleischman on 3/2/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) NSDictionary *photo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
