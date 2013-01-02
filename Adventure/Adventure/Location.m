//
//  Location.m
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import "Location.h"
#include <math.h>
@implementation Location
@dynamic creationDate;
@dynamic latitude;
@dynamic longitude;
@dynamic adventure;
@dynamic jsonData;
-(id)copyWithZone:(NSZone *)zone
{
    Location* copy = [[Location alloc] init];
    copy.creationDate = [self.creationDate copy];
    copy.latitude = [self.latitude copy];
    copy.longitude = [self.longitude copy];
    copy.adventure = [self.adventure copy];
    copy.jsonData = [self.jsonData copy];
    return copy;
}

- (BOOL)isSignificantDistanceFrom:(Location*)otherLoc {
    double R = 6371; // km
    double dLat = ([otherLoc.latitude doubleValue]-[self.latitude doubleValue]) * M_PI / 180.0;
    double dLon = ([otherLoc.longitude doubleValue]-[self.longitude doubleValue]) * M_PI / 180.0;
    double lat1 = [self.latitude doubleValue] * M_PI / 180.0;
    double lat2 = [otherLoc.latitude doubleValue] * M_PI / 180.0;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = R * c;
    NSLog(@"The distance Between the points in meters is %.10f", d);
    return d > 10.0;
}

@end
