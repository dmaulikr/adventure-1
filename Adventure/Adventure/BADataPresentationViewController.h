//
//  BADataPresentationViewController.h
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BADataPresentationViewController : UITableViewController

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *locationsArray;

@end
