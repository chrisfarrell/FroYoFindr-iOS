//
//  FYFLocationDetailViewController.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFLocationDetailViewController.h"

@interface FYFLocationDetailViewController ()

@end

@implementation FYFLocationDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if([self.annotation respondsToSelector:@selector(descriptionDetail)]){
        //NSString *desc = [self.annotation descriptionDetail];
        //DDLogVerbose(@"description: %@", desc);
        [self.labelOutlet setText:[self.annotation title]];
       // [self.textView setText:desc];
        [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[self.annotation url]]];
    }else{
        [self.labelOutlet setText:@"Error"];
        [self.textView setText:@"No Data Available"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self performSegueWithIdentifier:@"backToMap" sender:self];
}
@end
