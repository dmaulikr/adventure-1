//
//  Location.m
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import "Location.h"

@implementation Location
@dynamic creationDate;
@dynamic latitude;
@dynamic longitude;
@dynamic adventure;

-(id)copyWithZone:(NSZone *)zone
{
    Location* copy = [[Location alloc] init];
    copy.creationDate = [self.creationDate copy];
    copy.latitude = [self.latitude copy];
    copy.longitude = [self.longitude copy];
    self.adventure = [self.adventure copy];
    return copy;
}

@end
