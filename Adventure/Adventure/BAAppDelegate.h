//
//  BAAppDelegate.h
//  Adventure
//
//  Created by Tal Levy on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAAppDelegate : UIResponder <UIApplicationDelegate> {
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
