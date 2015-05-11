//
//  MapViewController.m
//  TestStation
//
//  Created by Sachith Gullapalli on 12/26/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import "MapViewController.h"
#import "CLLocationWithEqualityTest.h"

@interface MapViewController ()
@property (strong,nonatomic) RMMapView *mapView;
@property (strong,nonatomic) NSMutableArray *waypoints;
@property (strong,nonatomic) RMPolylineAnnotation *path;
@end




@implementation MapViewController

- (void)transmitter:(UIButton *) sender
{
    NSLog(@"GOT BUTTON PRESS");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocationCoordinate2D defaultcoord = {37.224920, -80.018715};
    RMMapboxSource *mapSource = [[RMMapboxSource alloc] initWithMapID:@"sachith.ido0pogc"];
    CGRect reducedSize = self.view.bounds;
    reducedSize.origin.y += 20;
    reducedSize.size.height -= 20;
    self.mapView = [[RMMapView alloc] initWithFrame:reducedSize andTilesource:mapSource];
    self.mapView.maxZoom = 18;
    self.mapView.minZoom = 2;
    self.mapView.zoom = 17;
    NSLog(@"View initialized");
    [self.view addSubview:self.mapView];
    [self.mapView setCenterCoordinate: defaultcoord];
    self.mapView.delegate = self;
    self.waypoints = [NSMutableArray arrayWithCapacity:50];
    self.path = NULL;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setMasksToBounds:true];
    [button.layer setCornerRadius:10.0f];
    [button addTarget:self action:@selector(transmitter:) forControlEvents:UIControlEventTouchDown];
    [button.layer setBackgroundColor:[UIColor redColor].CGColor];
    [button setTitle:@"Transmit" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState: UIControlStateHighlighted];
    button.frame = CGRectMake(260.0, 20.0, 80.0, 30.0);
    [self.mapView addSubview:button];
}

- (void)longPressOnMap:(RMMapView *)map at:(CGPoint)point
{
    NSLog(@"Gesture recognized");
    CLLocationCoordinate2D waypointCoord = [self.mapView pixelToCoordinate:point];
    RMAnnotation *newWaypoint = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:waypointCoord andTitle:@([self.waypoints count]).stringValue];
    newWaypoint.layer = [[RMMarker alloc] initWithMapboxMarkerImage:@"square-stroked" tintColorHex:@"#ff0000" sizeString:@"medium"];
    [self.mapView addAnnotation:newWaypoint];
    [self.waypoints addObject:[[CLLocationWithEqualityTest alloc] initWithLatitude:waypointCoord.latitude longitude:waypointCoord.longitude]];
    RMPolylineAnnotation *newLine = [[RMPolylineAnnotation alloc] initWithMapView:self.mapView points:self.waypoints];
    if (self.path != NULL) [self.mapView removeAnnotation: self.path];
    self.path = newLine;
    [self.mapView addAnnotation:newLine];
    
    
}

- (void) doubleTapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    [self.mapView removeAnnotation: self.path];
    [self.mapView removeAnnotation: annotation];
    [self.waypoints removeObject:[[CLLocationWithEqualityTest alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude]];
    if ([self.waypoints count] > 0)
    {
        RMPolylineAnnotation *newLine = [[RMPolylineAnnotation alloc] initWithMapView:self.mapView points:self.waypoints];
        [self.mapView addAnnotation:newLine];
        self.path = newLine;
    }
    else
    {
        self.path = NULL;
    }
}

- (void)mapView:(RMMapView *)mapView annotation:(RMAnnotation *)annotation didChangeDragState:(RMMapLayerDragState)newState fromOldState:(RMMapLayerDragState)oldState
{
    if (oldState == RMMapLayerDragStateNone)
        draggedAnnotation = annotation.coordinate;
    if (oldState == RMMapLayerDragStateDragging)
    {
        [self.mapView removeAnnotation: self.path];
        
        NSUInteger removeIndex = [self.waypoints indexOfObject:[[CLLocationWithEqualityTest alloc] initWithLatitude:draggedAnnotation.latitude longitude:draggedAnnotation.longitude]];
        [self.waypoints removeObjectAtIndex:removeIndex];
        [self.waypoints insertObject:[[CLLocationWithEqualityTest alloc] initWithLatitude: annotation.coordinate.latitude longitude:annotation.coordinate.longitude] atIndex:removeIndex];
        
            RMPolylineAnnotation *newLine = [[RMPolylineAnnotation alloc] initWithMapView:self.mapView points:self.waypoints];
            [self.mapView addAnnotation:newLine];
            self.path = newLine;
    }
}
- (BOOL) mapView:(RMMapView *)mapView shouldDragAnnotation:(RMAnnotation *)annotation
{
    return true;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
