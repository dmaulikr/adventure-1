//
//  BAMainViewController.h
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
@interface BAMainViewController : UIViewController <CLLocationManagerDelegate> {

    UIBackgroundTaskIdentifier task;
    BOOL backgroundStarted;
    int advNum;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *locationsArray;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIButton *locButton;
@property (strong, nonatomic) IBOutlet UIButton *endButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) NSTimer *timer;
- (CLLocation*)getLocation;
- (IBAction)activateBackground:(id)sender;
- (IBAction)endAdventure:(id)sender;
- (IBAction)startAdventure:(id)sender;
- (void)reverseGeocodeWithLoc:(Location*) loc andBlock:(void(^)(Location*, NSData*)) block;

@end
