//
//  FYFClientPushViewController.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/18/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYFClientPushViewController : UIViewController
- (IBAction)sendClientPush:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;

@end
