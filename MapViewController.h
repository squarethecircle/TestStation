//
//  MapViewController.h
//  TestStation
//
//  Created by Sachith Gullapalli on 12/26/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapbox.h"

@interface MapViewController : UIViewController<RMMapViewDelegate>
{
    CLLocationCoordinate2D draggedAnnotation;
}
@end
