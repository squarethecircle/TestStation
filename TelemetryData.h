//
//  TelemetryData.h
//  TestStation
//
//  Created by Sachith Gullapalli on 5/12/15.
//  Copyright (c) 2015 Grovio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE.h"

@protocol TelemetryDataDelegate
-(void)updateTelemetry:(NSString*) newTelemetry;
@end

@interface TelemetryData : NSObject
    @property (nonatomic, assign) id  delegate;
    @property (strong,nonatomic) BLE *bleShield;
    -(NSMutableString*)getTelemetry;
    -(NSMutableString*)appendTelemetry:(NSString*) newString;
    +(TelemetryData*)telemetryDataFactory;
    - (id)delegate;
    - (void)setDelegate:(id)newDelegate;

@end
