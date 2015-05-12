//
//  MapViewController.h
//  TestStation
//
//  Created by Sachith Gullapalli on 12/26/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapbox.h"
#import "BLE.h"

@interface MapViewController : UIViewController<RMMapViewDelegate, BLEDelegate>
{
    CLLocationCoordinate2D draggedAnnotation;
    UIActivityIndicatorView *activityIndicator;
}
@end
