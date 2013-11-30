//
//  FYFClientPushViewController.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/18/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFClientPushViewController.h"
#import "FYFLocationManager.h"

@interface FYFClientPushViewController ()

@end

@implementation FYFClientPushViewController

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    if ((self = [super initWithCoder:aDecoder])) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendClientPush:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableString* flavor = [[NSMutableString alloc] init];
    if([defaults boolForKey:CHOCOLATE]){
        [flavor setString:CHOCOLATE];
    }else if([defaults boolForKey:VANILLA]){
        [flavor setString:VANILLA];
    }else if([defaults boolForKey:STRAWBERRY]){
        [flavor setString:STRAWBERRY];
    }
    
    NSString* locality = [defaults stringForKey:LOCALITY];
    NSString* message = [NSString stringWithFormat:@"%@ is full of good deals! Get $1 Off %@ FroYo right here!", locality, flavor];
    NSTimeInterval interval = 60;
    NSArray* channels = [NSArray arrayWithObjects:flavor, nil];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          channels, @"channels",
                          1, @"isClientPush",
                          locality, @"locality",
                          nil];
    
    PFPush *iOSPush = [[PFPush alloc] init];
    [iOSPush expireAfterTimeInterval:interval];
    [iOSPush setData:data];
    [iOSPush sendPushInBackground];
}
@end
