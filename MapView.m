//
//  MapView.m
//  TestStation
//
//  Created by Sachith Gullapalli on 12/27/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import "MapView.h"

@implementation MapView


- (void)baseInit
{
    CLLocationCoordinate2D defaultcoord = {37.224920, -80.018715};
    RMMapboxSource *mapSource = [[RMMapboxSource alloc] initWithMapID:@"sachith.ido0pogc"];
    self.mapView = [[RMMapView alloc] initWithFrame:self.frame andTilesource:mapSource];
    self.mapView.centerCoordinate = defaultcoord;
    self.mapView.maxZoom = 18;
    self.mapView.minZoom = 2;
    self.mapView.zoom = 17;
    self.mapView.delegate = self;
    self.waypoints = [NSMutableArray arrayWithCapacity:50];
    self.path = NULL;
    [self addSubview: self.mapView];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self baseInit];
    }
    NSLog(@"View initialized");
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self baseInit];
    }
    NSLog(@"View initialized");
    return self;
}


- (void)longPressOnMap:(RMMapView *)map at:(CGPoint)point
{
    NSLog(@"Gesture recognized");
    CLLocationCoordinate2D waypointCoord = [self.mapView pixelToCoordinate:point];
    RMAnnotation *newWaypoint = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:waypointCoord andTitle:@([self.waypoints count]).stringValue];
    newWaypoint.layer = [[RMMarker alloc] initWithMapboxMarkerImage:@"square-stroked" tintColorHex:@"#ff0000" sizeString:@"small"];
    [self.mapView addAnnotation:newWaypoint];
    [self.waypoints addObject:[[CLLocationWithEqualityTest alloc] initWithLatitude:waypointCoord.latitude longitude:waypointCoord.longitude]];
    RMPolylineAnnotation *newLine = [[RMPolylineAnnotation alloc] initWithMapView:self.mapView points:self.waypoints];
    if (self.path != NULL) [self.mapView removeAnnotation: self.path];
    self.path = newLine;
    [self.mapView addAnnotation:newLine];
    
    
}

- (void) longPressOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    [self.mapView removeAnnotation: self.path];
    [self.mapView removeAnnotation: annotation];
    [self.waypoints removeObject:[[CLLocationWithEqualityTest alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude]];
    RMPolylineAnnotation *newLine = [[RMPolylineAnnotation alloc] initWithMapView:self.mapView points:self.waypoints];
    [self.mapView addAnnotation:newLine];
    self.path = newLine;
    
}


@end
