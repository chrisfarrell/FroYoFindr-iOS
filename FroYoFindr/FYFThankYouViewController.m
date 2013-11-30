//
//  FYFThankYouViewController.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/18/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFThankYouViewController.h"

@interface FYFThankYouViewController (){
    NSNumber* _currentSliderValue;
}
@end

@implementation FYFThankYouViewController

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    if ((self = [super initWithCoder:aDecoder])) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentSliderValue = [NSNumber numberWithInt:[self.slider value]];
    [self.sliderValueLabel setText:[_currentSliderValue stringValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(id)sender {
    _currentSliderValue = [NSNumber numberWithInt:[self.slider value]];
    [self.sliderValueLabel setText:[_currentSliderValue stringValue]];
}

- (IBAction)submitButton:(id)sender {

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setValue:_currentSliderValue forKey:@"rating"];
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}
@end
