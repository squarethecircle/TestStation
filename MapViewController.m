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

@interface MapViewController ()
@property (strong,nonatomic) RMMapView *mapView;
@property (strong,nonatomic) NSMutableArray *waypoints;
@property (strong,nonatomic) RMPolylineAnnotation *path;
@property (strong,nonatomic) BLE *bleShield;
@end




@implementation MapViewController

- (void)transmitter:(UIButton *) sender
{
    NSLog(@"GOT BUTTON PRESS");
}


-(void) connectionTimer:(NSTimer *)timer
{
    if(self.bleShield.peripherals.count > 0)
    {
        [self.bleShield connectPeripheral:[self.bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [activityIndicator stopAnimating];
        //self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message Received"
                                                                                    message:s
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

    }

-(void) bleDidConnect
{
    [activityIndicator stopAnimating];
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

- (void)connectBluetooth:(UIButton *) sender
{
    if (self.bleShield.activePeripheral)
        if(self.bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[self.bleShield CM] cancelPeripheralConnection:[self.bleShield activePeripheral]];
            return;
        }
    
    if (self.bleShield.peripherals)
        self.bleShield.peripherals = nil;
    
    [self.bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    //[self.mapView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    //self.navigationItem.leftBarButtonItem.enabled = NO;

}



- (void)viewDidLoad
{
    [super viewDidLoad];
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
    UIBarButtonItem *connect = [[UIBarButtonItem alloc] initWithTitle:@"Connect" style:UIBarButtonItemStylePlain target:self action:@selector(connectBluetooth:)];
    
    [button setTintColor:[UIColor whiteColor]];
    [connect setTintColor:[UIColor whiteColor]];
    //[button.layer setMasksToBounds:true];
    //[button.layer setCornerRadius:10.0f];
    //[button addTarget:self action:@selector(transmitter:) forControlEvents:UIControlEventTouchDown];
    //[button.layer setBackgroundColor:[UIColor redColor].CGColor];
    //[button setTitle:@"Transmit" forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    //[button setTitleColor:[UIColor blueColor] forState: UIControlStateHighlighted];
    //button.frame = CGRectMake(260.0, 20.0, 80.0, 30.0);
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:connect, flex, button,nil]];
    [self.mapView addSubview:toolbar];
    [self.view addSubview:activityIndicator];
    //[self.mapView addSubview:button];
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
