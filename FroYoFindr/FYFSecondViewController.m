//
//  FYFSecondViewController.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFSecondViewController.h"
#import "FYFLocationManager.h"

@interface FYFSecondViewController ()

@end

@implementation FYFSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [_chocolateOutlet setOn:[defaults boolForKey:CHOCOLATE]];
    [_vanillaOutlet setOn:[defaults boolForKey:VANILLA]];
    [_strawberryOutlet setOn:[defaults boolForKey:STRAWBERRY]];
    
    [self initSelectedValues];
    
    [[FYFLocationManager sharedManager] addObserver:self forKeyPath:@"countChocolate" options:NSKeyValueObservingOptionNew context:nil];
    [[FYFLocationManager sharedManager] addObserver:self forKeyPath:@"countVanilla" options:NSKeyValueObservingOptionNew context:nil];
    [[FYFLocationManager sharedManager] addObserver:self forKeyPath:@"countStrawberry" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    int count = (int)[change objectForKey:NSKeyValueChangeNewKey];
    if ([keyPath isEqualToString:@"countChocolate"] ){
        [self.countChocolate setText:[NSString stringWithFormat:@"There are %i chocolate lovers nearby!", count]];
    }else if([keyPath isEqualToString:@"countVanilla"]){
        [self.countVanilla setText:[NSString stringWithFormat:@"There are %i vanilla lovers nearby!", count]];
    }else if([keyPath isEqualToString:@"countStrawberry"]){
        [self.countStrawberry setText:[NSString stringWithFormat:@"There are %i strawberry lovers nearby!", count]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chocolateToggle:(id)sender {
    
    [self toggleFlavor:CHOCOLATE sender:sender];
}

- (IBAction)vanillaToggle:(id)sender {
    
    [self toggleFlavor:VANILLA sender:sender];
}

- (IBAction)strawberryToggle:(id)sender {
    
    [self toggleFlavor:STRAWBERRY sender:sender];
}

/**
	While active, this VC keeps track of which flavor is currently selected.
    The flavor is stored in a string, and the corresponding UISwitch is stored as well.
    This enables us to manually toggle the previously selected switch off, when a new selection is made.
 */
- (void)initSelectedValues

{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:CHOCOLATE]){
        [self setSelectedFlavor:CHOCOLATE];
        [self setSelectedSwitch:_chocolateOutlet];
    }else if([defaults boolForKey:VANILLA]){
        [self setSelectedFlavor:VANILLA];
        [self setSelectedSwitch:_vanillaOutlet];
    }else if([defaults boolForKey:STRAWBERRY]){
        [self setSelectedFlavor:STRAWBERRY];
        [self setSelectedSwitch:_strawberryOutlet];
    }
}

- (void)toggleSelected:(NSString*)flavor selectedIsOn:(BOOL)isOn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:CHOCOLATE];
    [defaults setBool:NO forKey:VANILLA];
    [defaults setBool:NO forKey:STRAWBERRY];
    
    [_chocolateOutlet setOn:NO];
    [_vanillaOutlet setOn:NO];
    [_strawberryOutlet setOn:NO];
    
    if(isOn){
        [self setSelectedFlavor:flavor];
        [_selectedSwitch setOn:YES];
        [defaults setBool:YES forKey:flavor];
    }else{
        [self setSelectedFlavor:nil];
        [self setSelectedSwitch:nil];
    }   
}

- (void)toggleFlavor:(NSString*)flavorString sender:(id)sender{
    
    UISwitch* toggle = (UISwitch*)sender;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setCenter:[toggle center]];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    if(toggle.on){
        if ([self selectedFlavor] != nil) {
            [currentInstallation removeObject:[self selectedFlavor] forKey:CHANNELS]; /**< remove current value */
            [currentInstallation saveEventually];
        }
        [currentInstallation addUniqueObject:flavorString forKey:CHANNELS]; /**< add new value*/
        [self setSelectedSwitch:toggle];
    }else{
        [currentInstallation removeObject:flavorString forKey:CHANNELS];
    }
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        [activityIndicator removeFromSuperview];
        
        if (succeeded) {    /**< only set defaults if parse call was successful */
            [self toggleSelected:flavorString selectedIsOn:toggle.on];
            
            int minor = -1;
            if([flavorString isEqualToString:CHOCOLATE]){
                minor = Chocolate;
            }else if([flavorString isEqualToString:VANILLA]){
                minor = Vanilla;
            }else if([flavorString isEqualToString:STRAWBERRY]){
                minor = Strawberry;
            }
            
            if(minor >= 0){
                [[FYFLocationManager sharedManager] advertiseWithMinor:minor];
            }
        }else{
            [toggle setOn:!toggle.isOn animated:YES]; /**< error. Undo user action (ideally with error) */
        }

    }];
}

@end
