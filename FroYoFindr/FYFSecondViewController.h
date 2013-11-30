//
//  FYFSecondViewController.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FYFSecondViewController : UIViewController
- (IBAction)chocolateToggle:(id)sender;
- (IBAction)vanillaToggle:(id)sender;
- (IBAction)strawberryToggle:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *chocolateOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *vanillaOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *strawberryOutlet;
@property (weak, nonatomic) IBOutlet UILabel *countChocolate;
@property (weak, nonatomic) IBOutlet UILabel *countVanilla;
@property (weak, nonatomic) IBOutlet UILabel *countStrawberry;

@property (strong, nonatomic) UISwitch *selectedSwitch;
@property(strong, nonatomic) NSString* selectedFlavor;
@end
