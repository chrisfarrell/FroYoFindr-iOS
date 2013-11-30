//
//  FYFFirstViewController.h
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FYFFirstViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
