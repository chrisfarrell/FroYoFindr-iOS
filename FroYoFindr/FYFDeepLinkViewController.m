//
//  FYFDeepLinkViewController.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/16/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFDeepLinkViewController.h"

@interface FYFDeepLinkViewController ()

@end

@implementation FYFDeepLinkViewController

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    if ((self = [super initWithCoder:aDecoder])) {
        self.images = [[NSMutableArray alloc] init];
        NSArray* names = [[NSArray alloc]
                          initWithObjects:@"chocolate",
                          @"vanilla",
                          @"strawberry",nil];
        int count = [names count];
        for (int i=0; i<count; i++) {
            UIImage* img = [UIImage imageNamed:[names objectAtIndex:i]];
            [self.images addObject:img];
        }
        
        _currentImageIndex = 0;
        

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self showImageAtIndex:[self currentImageIndex]];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImageAtIndex:(int)index
{
    [self setCurrentImageIndex:index];
    self.imageView.image = [self.images objectAtIndex:_currentImageIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
