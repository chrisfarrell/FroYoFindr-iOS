//
//  FYFThankYouViewController.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/18/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYFThankYouViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *sliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)submitButton:(id)sender;

@end
