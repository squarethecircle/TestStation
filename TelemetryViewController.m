//
//  TelemetryViewController.m
//  TestStation
//
//  Created by Sachith Gullapalli on 12/27/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import "TelemetryViewController.h"

@interface TelemetryViewController ()
{
    UITextView* telemetryView;
}

@end

@implementation TelemetryViewController
static TelemetryData* telemetryData;

- (void)viewDidLoad {
    [super viewDidLoad];
    telemetryData = [TelemetryData telemetryDataFactory];
    telemetryData.delegate = self;
    [self setNeedsStatusBarAppearanceUpdate];
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,64)];
    [toolbar setBarTintColor: [[UIColor alloc] initWithRed:31/255.f green:58/255.f blue:147/255.f alpha:0.9]];
    [toolbar setTranslucent:YES];
    
    UIFont* courierNew = [UIFont fontWithName:@"Courier New" size: 20.0];
    telemetryView = [[UITextView alloc] initWithFrame:CGRectMake(0,64,self.view.bounds.size.width,
                                                                 self.view.bounds.size.height - 64 - 49)];
    [telemetryView setFont:courierNew];
    [telemetryView setEditable:NO];
    telemetryView.layoutManager.allowsNonContiguousLayout = NO;
    [telemetryView setText: [telemetryData getTelemetry]];
    [self.view addSubview:toolbar];
    [self.view addSubview:telemetryView];
    // Do any additional setup after loading the view.
}

-(void)updateTelemetry:(NSString*) newTelemetry;
{
    //[telemetryView setScrollEnabled:NO];
    //CGPoint p = [telemetryView contentOffset];
    [telemetryView setText: newTelemetry];
    //[telemetryView setScrollEnabled:YES];
    //[telemetryView setContentOffset:p animated:NO];
    [UIView setAnimationsEnabled:NO];
    [telemetryView scrollRangeToVisible:NSMakeRange([telemetryView.text length], 0)];
    [UIView setAnimationsEnabled:YES];
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
