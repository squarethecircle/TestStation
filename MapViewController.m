//
//  MapViewController.m
//  TestStation
//
//  Created by Sachith Gullapalli on 12/26/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import "MapViewController.h"
#import "CLLocationWithEqualityTest.h"
#import "BLE.h"
#import "TelemetryData.h"

@interface MapViewController ()
@property (strong,nonatomic) RMMapView *mapView;
@property (strong,nonatomic) NSMutableArray *waypoints;
@property (strong,nonatomic) RMPolylineAnnotation *path;
@end




@implementation MapViewController
TelemetryData* telemetryData;

- (void)transmitter:(UIButton *) sender
{
    NSLog(@"%d",_mapView.annotations.count);
}


-(void) connectionTimer:(NSTimer *)timer
{
    if(telemetryData.bleShield.peripherals.count > 0)
    {
        [telemetryData.bleShield connectPeripheral:[telemetryData.bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Bluetooth Connection Error"
                                                                       message:@"BLE Not Found"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        [activityIndicator stopAnimating];
        //self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    [telemetryData appendTelemetry:s];
       
    }

-(void) bleDidConnect
{
    [activityIndicator stopAnimating];
    bluetoothConnected = YES;
    connectToggle.title = @"Disconnect";
    //self.navigationItem.leftBarButtonItem.enabled = YES;
    //[self.navigationItem.leftBarButtonItem setTitle:@"Disconnect"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Bluetooth Setup"
                                                                   message:@"You have connected."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    NSLog(@"bleDidConnect");
}

-(void) bleDidDisconnect
{
    bluetoothConnected = NO;
    connectToggle.title = @"Connect";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Bluetooth Setup"
                                                                   message:@"You have disconnected."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"bleDidDisconnect");
}
- (void)connectBluetooth
{
    if (telemetryData.bleShield.activePeripheral)
        if(telemetryData.bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[telemetryData.bleShield CM] cancelPeripheralConnection:[telemetryData.bleShield activePeripheral]];
            NSLog(@"WHAT???");
            return;
        }
    
    if (telemetryData.bleShield.peripherals)
        telemetryData.bleShield.peripherals = nil;
    NSLog(@"QAT???");
    [telemetryData.bleShield findBLEPeripherals:3];
    NSLog(@"ZAT???");
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    //[self.mapView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    //self.navigationItem.leftBarButtonItem.enabled = NO;

}

- (void)disconnectBluetooth
{
    if (telemetryData.bleShield.activePeripheral)
        if(telemetryData.bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[telemetryData.bleShield CM] cancelPeripheralConnection:[telemetryData.bleShield activePeripheral]];
            return;
        }
    
    if (telemetryData.bleShield.peripherals)
        telemetryData.bleShield.peripherals = nil;
}

- (void)toggleBluetooth:(UIButton *) sender
{
    if (bluetoothConnected)
    {
        NSLog(@"Disconnecting...");
      [self disconnectBluetooth];
    }
    else
    {
        NSLog(@"Connecting...");
       [self connectBluetooth];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    telemetryData = [TelemetryData telemetryDataFactory];
    bluetoothConnected = NO;
    telemetryData.bleShield = [[BLE alloc] init];
    [telemetryData.bleShield controlSetup];
    telemetryData.bleShield.delegate = self;
    [self setNeedsStatusBarAppearanceUpdate];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,64)];
    [toolbar setBarTintColor: [[UIColor alloc] initWithRed:31/255.f green:58/255.f blue:147/255.f alpha:0.9]];
    [toolbar setTranslucent:YES];
    CLLocationCoordinate2D defaultcoord = {37.224920, -80.018715};
    RMMapboxSource *mapSource = [[RMMapboxSource alloc] initWithMapID:@"sachith.ido0pogc"];
    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:mapSource];
    self.mapView.maxZoom = 18;
    self.mapView.minZoom = 2;
    self.mapView.zoom = 17;
    NSLog(@"View initialized");
    [self.view addSubview:self.mapView];
    [self.mapView setCenterCoordinate: defaultcoord];
    self.mapView.delegate = self;
    self.waypoints = [NSMutableArray arrayWithCapacity:50];
    self.path = NULL;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Transmit" style:UIBarButtonItemStylePlain target:self action:@selector(transmitter:)];
   connectToggle = [[UIBarButtonItem alloc] initWithTitle:@"Connect" style:UIBarButtonItemStylePlain target:self action:@selector(toggleBluetooth:)];
    
    [button setTintColor:[UIColor whiteColor]];
    [connectToggle setTintColor:[UIColor whiteColor]];
    //[button.layer setMasksToBounds:true];
    //[button.layer setCornerRadius:10.0f];
    //[button addTarget:self action:@selector(transmitter:) forControlEvents:UIControlEventTouchDown];
    //[button.layer setBackgroundColor:[UIColor redColor].CGColor];
    //[button setTitle:@"Transmit" forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    //[button setTitleColor:[UIColor blueColor] forState: UIControlStateHighlighted];
    //button.frame = CGRectMake(260.0, 20.0, 80.0, 30.0);
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:connectToggle, flex, button,nil]];
    [self.mapView addSubview:toolbar];
    [self.view addSubview:activityIndicator];
    //[self.mapView addSubview:button];
}

- (void)longPressOnMap:(RMMapView *)map at:(CGPoint)point
{
    NSLog(@"Gesture recognized");
    CLLocationCoordinate2D waypointCoord = [self.mapView pixelToCoordinate:point];
    [self.waypoints addObject:[[CLLocationWithEqualityTest alloc] initWithLatitude:waypointCoord.latitude longitude:waypointCoord.longitude]];
    RMAnnotation *newWaypoint = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:waypointCoord andTitle:@([self.waypoints count]).stringValue];

    [self.mapView addAnnotation:newWaypoint];
    RMPolylineAnnotation *newLine = [[RMPolylineAnnotation alloc] initWithMapView:self.mapView points:self.waypoints];
    if (self.path != NULL) [self.mapView removeAnnotation: self.path];
    self.path = newLine;
    [self.mapView addAnnotation:newLine];
    
    
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    CLLocationWithEqualityTest* query = [[CLLocationWithEqualityTest alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    NSUInteger index = [_waypoints indexOfObject:query]+1;
    //UIImage* icon = [[UIImage alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"mapIcons/red83.png"]];
    return [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:[[NSString alloc] initWithFormat:@"red%02lu",(unsigned long)index]]];
}


- (void) doubleTapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    [self.waypoints removeObject:[[CLLocationWithEqualityTest alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude]];
    [self.mapView removeAllAnnotations];
    if ([self.waypoints count] > 0)
    {
        RMPolylineAnnotation *newLine = [[RMPolylineAnnotation alloc] initWithMapView:self.mapView points:self.waypoints];
        [self.mapView addAnnotation:newLine];
        self.path = newLine;
        for (CLLocationWithEqualityTest* waypoint in _waypoints)
        {
            CLLocationCoordinate2D waypointCoord = {waypoint.coordinate.latitude, waypoint.coordinate.longitude};
            RMAnnotation *newWaypoint = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:waypointCoord andTitle:@([self.waypoints count]).stringValue];
            [self.mapView addAnnotation:newWaypoint];
        }
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
