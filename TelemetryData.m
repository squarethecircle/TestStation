//
//  TelemetryData.m
//  TestStation
//
//  Created by Sachith Gullapalli on 5/12/15.
//  Copyright (c) 2015 Grovio. All rights reserved.
//

#import "TelemetryData.h"
@interface TelemetryData ()
    @property(strong,nonatomic) NSMutableString* telemetryText;
@end
@implementation TelemetryData
@synthesize delegate;

static TelemetryData* currentData = nil;
- (NSMutableString*)getTelemetry
{
    return currentData.telemetryText;
}

- (NSMutableString*)appendTelemetry:(NSString* )newString
{
    [currentData.telemetryText appendFormat:@"%@\n",newString];
    [delegate updateTelemetry:_telemetryText];
    return currentData.telemetryText;
}


+ (TelemetryData*)telemetryDataFactory
{
    if (!currentData)
    {
        currentData = [[self alloc] init];
        currentData.telemetryText = [[NSMutableString alloc] initWithString:@""];
    }
    return currentData;
}


@end
