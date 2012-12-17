//
//  Adventure.h
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Adventure : NSManagedObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *number;

@end
