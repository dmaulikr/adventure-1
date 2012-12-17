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
    CLLocationManager *locationManager;
    UIBackgroundTaskIdentifier task;
    BOOL backgroundStarted;
}
@property (strong, nonatomic) IBOutlet UIButton *locButton;
@property (strong, nonatomic) IBOutlet UIButton *endButton;
@property (retain, nonatomic) NSTimer *timer;
- (CLLocation*)getLocation;
- (IBAction)activateBackground:(id)sender;
- (IBAction)endAdventure:(id)sender;

@end
