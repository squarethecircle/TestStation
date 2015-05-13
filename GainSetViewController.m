//
//  GainSetViewController.m
//  TestStation
//
//  Created by Sachith Gullapalli on 5/10/15.
//  Copyright (c) 2015 Grovio. All rights reserved.
//

#import "GainSetViewController.h"


@implementation GainSetViewController

- (void)transmitter:(UIButton *) sender
{
    NSString* transmitString = [[NSString alloc] initWithFormat:@"G%@%ld%ldQ",_code,9-[picker selectedRowInComponent:0],9-[picker selectedRowInComponent:1]];
    NSLog(transmitString);
    _currentVal[0] = [NSNumber numberWithInteger:(NSInteger)9-[picker selectedRowInComponent:0]];
    _currentVal[1] = [NSNumber numberWithInteger:(NSInteger)9-[picker selectedRowInComponent:1]];
    TelemetryData* currentBluetooth = [TelemetryData telemetryDataFactory];
    if (![currentBluetooth.bleShield isConnected])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Bluetooth Connection Error"
                                                                       message:@"BLE Not Found"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [currentBluetooth.bleShield write:[transmitString dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setBarTintColor: [[UIColor alloc] initWithRed:31/255.f green:58/255.f blue:147/255.f alpha:0.9]];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setMasksToBounds:true];
    [button.layer setCornerRadius:10.0f];
    [button addTarget:self action:@selector(transmitter:) forControlEvents:UIControlEventTouchDown];
    [button.layer setBackgroundColor:[UIColor redColor].CGColor];
    [button setTitle:@"Transmit" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState: UIControlStateHighlighted];
    button.frame = CGRectMake(self.view.frame.size.width/2 - 40, self.view.frame.size.height/2 + 30, 80, 30);
    [self.view addSubview:button];
    
    picker = [[UIPickerView alloc] init];
    picker.frame = CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 150, 200, 20);
    picker.dataSource = self;
    picker.delegate = self;
    [picker selectRow:9-((NSNumber*)self.currentVal[0]).intValue inComponent:0 animated:false];
    [picker selectRow:9-((NSNumber*)self.currentVal[1]).intValue inComponent:1 animated:false];

    [self.view addSubview:picker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view != nil) return view;
    NSString* num = [NSString stringWithFormat:@"%d", 9-(int)row];
    UILabel* numLabel = [[UILabel alloc] init];
    numLabel.text = num;
    numLabel.font = [UIFont systemFontOfSize:100];
    return numLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 80;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
