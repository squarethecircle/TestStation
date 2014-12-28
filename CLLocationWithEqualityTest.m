//
//  CLLocationWithEqualityTest.m
//  TestStation
//
//  Created by Sachith Gullapalli on 12/27/14.
//  Copyright (c) 2014 Grovio. All rights reserved.
//

#import "CLLocationWithEqualityTest.h"

@implementation CLLocationWithEqualityTest

- (BOOL) isEqual:(id)other
{
    if ([other isKindOfClass:[CLLocation class]])
    {
        
        if ([self distanceFromLocation:other] == 0)
        {
            return true;
        }
        return false;
    }
    else return [super isEqual:other];
}

@end
