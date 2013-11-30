//
//  FYFLocationManager.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 11/17/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define CHOCOLATE        @"chocolate"
#define VANILLA          @"vanilla"
#define STRAWBERRY       @"strawberry"

#define CHANNELS         @"channels"
#define FLAVORS          @"flavors"
#define LOCALITY         @"locality"

@interface FYFLocationManager : NSObject <CLLocationManagerDelegate, CBPeripheralManagerDelegate>

enum {
    Chocolate,
    Vanilla,
    Strawberry
};

typedef int Flavor;

+ (id)sharedManager;
- (void)advertiseWithMinor:(int)minor;
- (void)stopAdvertising;

/**
    Location Manager that keep track of location and looks for beacons.
 */
@property (strong, nonatomic) CLLocationManager *locationManager;

/**
    Roximity beacon region that location manager is looking for.
 */
@property (strong, nonatomic) CLBeaconRegion *roxBeaconRegion;

/**
    App beacon region that location manager is looking for.
 */
@property (strong, nonatomic) CLBeaconRegion *appBeaconRegion;


/**
	When device is transmitting, the device transmits to this region.
 */
@property (strong, nonatomic) CLBeaconRegion *transmitBeaconRegion;

/**
	When device is transmitting, this dictionary is used to store the data for the region.
 */
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;

/**
	When device is transmitting, this manager does the transmit.
 */
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

@property (assign) BOOL isInRangeOfBlackRoximityBeacon;
@property (assign) BOOL isUpdatingLocality;
@property (assign) int countChocolate;
@property (assign) int countVanilla;
@property (assign) int countStrawberry;

@end
