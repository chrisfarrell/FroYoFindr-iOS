//
//  FYFFirstViewController.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFFirstViewController.h"
#import "FYFMapPin.h"
#import "FYFLocationDetailViewController.h"
#import <MapKit/MapKit.h>


@interface FYFFirstViewController ()

@end

@implementation FYFFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ( [CLLocationManager locationServicesEnabled] ) {
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 1000;
        [self.locationManager startUpdatingLocation];
    }
    
    self.mapView.delegate = self;
    
   /*
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
    */
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    annotationView.image = [UIImage imageNamed:@"cone.png"];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    /*
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[[view annotation]coordinate] addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
     */
    [self performSegueWithIdentifier:@"froYoDeets" sender:[view annotation]];
    //[mapItem openInMapsWithLaunchOptions:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"froYoDeets"])
    {
        FYFLocationDetailViewController *detailVC = segue.destinationViewController;
        FYFMapPin *annotation = (FYFMapPin*)sender;
        [detailVC setAnnotation:annotation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    double miles = 2.0;
    double scalingFactor = ABS( cos(2 * M_PI * newLocation.coordinate.latitude /360.0) );
    
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/( scalingFactor*69.0 );
    MKCoordinateRegion region;
    region.span = span;
    region.center = newLocation.coordinate;
    [self.mapView setRegion:region animated:NO];
    self.mapView.showsUserLocation = YES;

    [self reloadAnnotations:region];
    
}

-(void)reloadAnnotations:(MKCoordinateRegion)region{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"frozen yogurt";
    request.region = region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        NSMutableArray *annotations = [NSMutableArray array];
        
        [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem *item, NSUInteger idx, BOOL *stop) {
            
//            
//            for (id<MKAnnotation>annotation in self.mapView.annotations)
//            {
//                if (annotation.coordinate.latitude == item.placemark.coordinate.latitude &&
//                    annotation.coordinate.longitude == item.placemark.coordinate.longitude)
//                {
//                    return;
//                }else{
//                    
//                    //[[item placemark] addressDictionary];
//                    //[[item placemark] ];
//                    NSLog(@"Name: %@", [item name] );
//                    FYFMapPin* pin = [[FYFMapPin alloc] initWithCoordinates:[item.placemark coordinate]
//                                                                  placeName:[item name]
//                                                                description:[item description]
//                                                                        url:[item url]
//                                      ];
//                    [self.mapView addAnnotation:pin];
//                }
//            }
//            

            NSLog(@"Name: %@", [item name] );
            FYFMapPin* pin = [[FYFMapPin alloc] initWithCoordinates:[item.placemark coordinate]
                                                          placeName:[item name]
                                                        description:[item description]
                                                                url:[item url]
                              ];
            [self.mapView addAnnotation:pin];
            [annotations addObject:item.placemark];
            
        }];
        
        [self.mapView addAnnotations:annotations];
    }];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self reloadAnnotations:self.mapView.region];
}

- (IBAction)unwindToMapView:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    /*
    if ([sourceViewController isKindOfClass:[BlueViewController class]])
    {
        NSLog(@"Coming from BLUE!");
    }
    else if ([sourceViewController isKindOfClass:[GreenViewController class]])
    {
        NSLog(@"Coming from GREEN!");
    }
     */
}

@end
