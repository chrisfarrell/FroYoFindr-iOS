//
//  FYFMapPin.m
//  FroYoFindr
//
//  Created by Christopher Farrell on 10/26/13.
//  Copyright (c) 2013 Chris Farrell. All rights reserved.
//

#import "FYFMapPin.h"

@implementation FYFMapPin

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description url:(NSURL*)url {
    self = [super init];
    if (self != nil) {
        _coordinate = location;
        _title = placeName;
        _subtitle = @"";//description;
        _descriptionDetail = description;
        _url = url;
    }
    return self;
}

@end

