//
//  MapView.h
//  TestStation
//
//  Created by Sachith Gullapalli on 12/27/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapbox.h"
#import "CLLocationWithEqualityTest.h"


@interface MapView : UIView<RMMapViewDelegate>
@property (strong,nonatomic) RMMapView *mapView;
@property (strong,nonatomic) NSMutableArray *waypoints;
@property (strong,nonatomic) RMPolylineAnnotation *path;
@end

