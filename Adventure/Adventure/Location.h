//
//  Location.h
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Location : NSManagedObject <NSCopying>
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *adventure;
@property (nonatomic, retain) NSData *jsonData;
@end
