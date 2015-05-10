//
//  GainSetViewController.m
//  TestStation
//
//  Created by Sachith Gullapalli on 5/10/15.
//  Copyright (c) 2015 Grovio. All rights reserved.
//

#import "GainSetViewController.h"

@implementation GainSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setMasksToBounds:true];
    [button.layer setCornerRadius:10.0f];
    //[button addTarget:self action:@selector(transmitter:) forControlEvents:UIControlEventTouchDown];
    [button.layer setBackgroundColor:[UIColor redColor].CGColor];
    [button setTitle:@"Transmit" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState: UIControlStateHighlighted];
    button.frame = CGRectMake(self.view.frame.size.width/2 - 40, self.view.frame.size.height/2 + 30, 80, 30);
    [self.view addSubview:button];
    
    UIPickerView* picker = [[UIPickerView alloc] init];
    picker.frame = CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 150, 200, 20);
    picker.dataSource = self;
    picker.delegate = self;
    [picker selectRow:((NSNumber*)self.currentVal[0]).intValue inComponent:0 animated:false];
    [picker selectRow:((NSNumber*)self.currentVal[1]).intValue inComponent:1 animated:false];
    [picker selectRow:((NSNumber*)self.currentVal[2]).intValue inComponent:2 animated:false];

    
    [self.view addSubview:picker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view != nil) return view;
    NSString* num = [NSString stringWithFormat:@"%d", row];
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
@end
