//
//  FYFDeepLinkViewController.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/16/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYFDeepLinkViewController : UIViewController


/**
 Mutable view used to display the various images.
 */
@property (nonatomic, strong)UIImageView *imageView;

/**
 Array to hold the immutable image instances.
 */
@property (nonatomic, strong)NSMutableArray *images;


/**
 Index of image being displayed.
 */
@property (nonatomic, assign)int currentImageIndex;


/**
 Public method to allow clients to change the currently shown image by index.
 @param index
 */
- (void)showImageAtIndex:(int)index;


@end
