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
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIButton *locButton;
@property (retain, nonatomic) NSTimer *timer;
- (CLLocation*)getLocation;
- (IBAction)activateBackground:(id)sender;

@end
