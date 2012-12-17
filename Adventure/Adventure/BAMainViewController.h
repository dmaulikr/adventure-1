//
//  BAMainViewController.h
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BAMainViewController : UIViewController <CLLocationManagerDelegate> {

    UIBackgroundTaskIdentifier task;
    BOOL backgroundStarted;
    NSNumber *advNum;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationsArray;

@property (strong, nonatomic) IBOutlet UIButton *locButton;
@property (strong, nonatomic) IBOutlet UIButton *endButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) NSTimer *timer;
- (CLLocation*)getLocation;
- (IBAction)activateBackground:(id)sender;
- (IBAction)endAdventure:(id)sender;
- (IBAction)startAdventure:(id)sender;
- (void)reverseGeocodeWithLoc:(CLLocation*) loc;

@end
