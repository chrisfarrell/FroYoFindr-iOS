//
//  FYFLocationManager.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/17/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFLocationManager.h"
#import "FYFLocalNotificationManager.h"
#import "FYFKeys.h"

@implementation FYFLocationManager


+ (id)sharedManager {
    static FYFLocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        
        [self initRegion];

    }
    return self;
}


/**
	Provides the location manager with 2 beacon regions to monitor.
    One for the Roximity beacons and one for other iPhones running this app and transmitting
 */
- (void)initRegion

{
    NSUUID *rox_uuid = [[NSUUID alloc] initWithUUIDString:ROXIMITY_UUID];
    self.roxBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:rox_uuid identifier:ROX_BEACON_ID];
    [self.locationManager startMonitoringForRegion:self.roxBeaconRegion];
    self.roxBeaconRegion.notifyEntryStateOnDisplay = YES;
    
    NSUUID *app_uuid = [[NSUUID alloc] initWithUUIDString:APP_UUID];
    self.appBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:app_uuid identifier:FYF_BEACON_ID];
    [self.locationManager startMonitoringForRegion:self.appBeaconRegion];
    self.appBeaconRegion.notifyEntryStateOnDisplay = YES;

}

/**
	Going to try and call this each time the user updates the flavor preference.
    Idea is that when they change their preference, the beacon they transmit should have a different minor number.
    The minor number will indicate the preference, so when a reciever see it, they can act accordingly.
	@param minor integer representing chocolate, vanilla, or strawberry
 */
- (void)advertiseWithMinor:(int)minor
{
    if ([self.peripheralManager isAdvertising]) {
        [self stopAdvertising];
        self.beaconPeripheralData = nil;
        self.peripheralManager = nil;
    }
    // advertise region
    CLBeaconRegion *advertisingRegion = [[CLBeaconRegion alloc]
                                         initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:APP_UUID]
                                         major:1
                                         minor:minor
                                         identifier:FYF_BEACON_ID];
    
    self.beaconPeripheralData = [advertisingRegion peripheralDataWithMeasuredPower:nil];
    
    self.peripheralManager = [[CBPeripheralManager alloc]
                                              initWithDelegate:self
                                              queue:dispatch_get_main_queue()];

}

- (void)stopAdvertising
{
    [self.peripheralManager stopAdvertising];
}


- (void)didRangeRoximityBeacons:(NSArray *)beacons
{
    int count = [beacons count];
    
    if ([beacons count] > 0) {
        for(int i = 0; i < count; i++ ){
            
            CLBeacon *beacon = [[CLBeacon alloc] init];
            beacon = [beacons objectAtIndex:i];

            if (beacon.proximity == CLProximityUnknown) {
                [self handleUnknownRoxBeacon:beacon];
            } else if (beacon.proximity == CLProximityImmediate) {
                [self handleImmediateRoxBeacon:beacon];
            } else if (beacon.proximity == CLProximityNear) {
                [self handleNearRoxBeacon:beacon];
            } else if (beacon.proximity == CLProximityFar) {
                [self handleFarRoxBeacon:beacon];
            }

        }
    }
}

- (void)didRangeAppBeacons:(NSArray *)beacons
{
    int count = [beacons count];
    
    if ([beacons count] > 0) {
        _countChocolate = 0;
        _countVanilla = 0;
        _countStrawberry = 0;
        for(int i = 0; i < count; i++ ){
            
            CLBeacon *beacon = [[CLBeacon alloc] init];
            beacon = [beacons objectAtIndex:i];
            
            if (beacon.proximity == CLProximityUnknown) {
                [self handleUnknownAppBeacon:beacon];
            } else if (beacon.proximity == CLProximityImmediate) {
                [self handleImmediateAppBeacon:beacon];
            } else if (beacon.proximity == CLProximityNear) {
                [self handleNearAppBeacon:beacon];
            } else if (beacon.proximity == CLProximityFar) {
                [self handleFarAppBeacon:beacon];
            }
            
        }
    }
    
}

/**
    No rules for this case yet, maybe reset some tbd state vars?
	@param beacon app beacon
 */
- (void)handleUnknownAppBeacon:(CLBeacon*)beacon
{
    
}

/**
	If the immediate detected beacon has a minor that matches this users preferences, we fire a local notification.
    Interaction with local notification leads to some special, contextual reveal.
    @param beacon app beacon
 */
- (void)handleImmediateAppBeacon:(CLBeacon*)beacon
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (beacon.minor.intValue) {
        case Chocolate:
            if([defaults boolForKey:CHOCOLATE]){
                //send local notification that leads to fun reveal
            }
            break;
        case Vanilla:
            if([defaults boolForKey:VANILLA]){
                //send local notification that leads to fun reveal
            }
            break;
        case Strawberry:
            if([defaults boolForKey:STRAWBERRY]){
                //send local notification that leads to fun reveal
            }
            break;
        default:
            break;
    }
}

/**
	Count the beacons for display purposes.
	@param beacon app beacon
 */
- (void)handleNearAppBeacon:(CLBeacon*)beacon
{
    switch (beacon.minor.intValue) {
        case Chocolate:
            self.countChocolate++;
            break;
        case Vanilla:
            self.countVanilla++;
            break;
        case Strawberry:
            self.countStrawberry++;
            break;
        default:
            break;
    }
}

/**
	Count the beacons for display purposes.
	@param beacon app beacon
 */
- (void)handleFarAppBeacon:(CLBeacon*)beacon
{
    switch (beacon.minor.intValue) {
        case Chocolate:
            self.countChocolate++;
            break;
        case Vanilla:
            self.countVanilla++;
            break;
        case Strawberry:
            self.countStrawberry++;
            break;
        default:
            break;
    }
}

/**
	Handles case when device doesn't know proximity of roximity beacon.
    If minor #109 (black), sets 'inrange' flag to NO.
    If minor #114 (pink), does nothing... for now.
	@param beacon roximity beacon
 */
- (void)handleUnknownRoxBeacon:(CLBeacon*)beacon

{
    switch (beacon.minor.intValue) {
            
        case MINOR_109_BLACK:
            self.isInRangeOfBlackRoximityBeacon = NO;
            break;
        default:
            break;
    }
}

/**
	Handles case when device comes in immediate proximity of roximity beacon.
    If minor #109 (black), try to fire a local notification, which, when recieved, launches modal.
    The modal will display the number of nearby devices transmitting that have same flavor preference.
    If minor #114 (pink), does nothing... for now.
 	@param beacon roximity beacon
 */
- (void)handleImmediateRoxBeacon:(CLBeacon*)beacon
{
    switch (beacon.minor.intValue) {
        case MINOR_109_BLACK:
            [[FYFLocalNotificationManager sharedManager] clientPushNotification];
            break;
        default:
            break;
    }
}


/**
	Handles case when device comes in near proximity of roximity beacon.
    If minor #109 (black), this will set an 'inrange' flag to true.
    The flag will help determine if this device should respond to silent pushes from others nearby.
    If minor #114 (pink), try to fire a local notification that, when interacted with, displays a thank you/survey.
 	@param beacon roximity beacon
 */
- (void)handleNearRoxBeacon:(CLBeacon*)beacon
{
    switch (beacon.minor.intValue) {
            
        case MINOR_109_BLACK:
            self.isInRangeOfBlackRoximityBeacon = YES;
            break;
        case MINOR_114_PINK:
            [[FYFLocalNotificationManager sharedManager] goodByeSurveyNotification];
            break;
            
        default:
            break;
    }
}

/**
     Handles case when device comes in far proximity of roximity beacon.
     If minor #109 (black), this will set an 'inrange' flag to true.
     The flag will help determine if this device should respond to silent pushes from others nearby.
     If minor #114 (pink), does nothing... for now.
 	@param beacon roximity beacon
 */
- (void)handleFarRoxBeacon:(CLBeacon*)beacon
{
    switch (beacon.minor.intValue) {
            
        case MINOR_109_BLACK:
            self.isInRangeOfBlackRoximityBeacon = YES;
            break;
        default:
            break;
    }
}

# pragma mark - Peripheral Manager Delegate

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        DDLogVerbose(@"Powered On");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        DDLogVerbose(@"Powered Off");
        [self.peripheralManager stopAdvertising];
    }
}

# pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //[self.locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            DDLogVerbose(@"didUpdateToLocation Locality = %@", placemark.locality);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString* storedLocality = [defaults stringForKey:LOCALITY];
            
            if( ![storedLocality isEqualToString:placemark.locality] && !_isUpdatingLocality){
                
                _isUpdatingLocality = YES;
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];

                if (storedLocality != nil) {
                    [currentInstallation removeObject:storedLocality forKey:CHANNELS];
                }
                
                [currentInstallation saveEventually];
                [currentInstallation addUniqueObject:placemark.locality forKey:CHANNELS];

                [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {    /**< set defaults if parse call was successful */
                        [defaults setObject:placemark.locality forKey:LOCALITY];
                    }else{
                        /*error*/
                    }
                    _isUpdatingLocality = NO;
                    
                }];
            }
        }
    }];
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    DDLogVerbose(@"didDetermineState");
    
    switch (state) {
        case CLRegionStateInside:
            [self.locationManager startRangingBeaconsInRegion:self.roxBeaconRegion];
            [self.locationManager startRangingBeaconsInRegion:self.appBeaconRegion];
            break;
        case CLRegionStateOutside:
        case CLRegionStateUnknown:
        default:
            [self.locationManager stopRangingBeaconsInRegion:self.roxBeaconRegion];
            [self.locationManager stopRangingBeaconsInRegion:self.appBeaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.roxBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.appBeaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.roxBeaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.appBeaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    //DDLogVerbose(@"didRangeBeacons");
    
    //can have different courses for bg/fg.
    //UIApplicationState state = [[UIApplication sharedApplication] applicationState];

    if([[region identifier] isEqualToString:ROX_BEACON_ID] ){
        [self didRangeRoximityBeacons:beacons];
    }else if([[region identifier] isEqualToString:FYF_BEACON_ID]){
        [self didRangeAppBeacons:beacons];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    //DDLogVerbose(@"didStartMonitoringForRegion");
    
    [self.locationManager startRangingBeaconsInRegion:self.roxBeaconRegion];
    [self.locationManager requestStateForRegion:self.roxBeaconRegion];
    
    [self.locationManager startRangingBeaconsInRegion:self.appBeaconRegion];
    [self.locationManager requestStateForRegion:self.appBeaconRegion];
}



@end
