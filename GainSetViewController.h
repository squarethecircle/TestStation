//
//  GainSetViewController.h
//  TestStation
//
//  Created by Sachith Gullapalli on 5/10/15.
//  Copyright (c) 2015 Grovio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TelemetryData.h"


@interface GainSetViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView* picker;
}
@property (weak,nonatomic) NSMutableArray* currentVal;
@property (weak, nonatomic) NSString* code;

@end
