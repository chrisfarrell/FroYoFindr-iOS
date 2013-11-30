//
//  FYFLocationDetailViewController.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYFMapPin.h"

@interface FYFLocationDetailViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSString* detailData;
@property (nonatomic, strong) FYFMapPin* annotation;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *labelOutlet;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (strong, nonatomic) NSURL *locationDetailURL;


- (IBAction)backButton:(id)sender;

@end
