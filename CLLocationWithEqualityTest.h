//
//  CLLocationWithEqualityTest.h
//  TestStation
//
//  Created by Sachith Gullapalli on 12/27/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocationWithEqualityTest : CLLocation
- (BOOL) isEqual:(id) other;
@end
