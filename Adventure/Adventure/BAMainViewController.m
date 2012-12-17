//
//  BAMainViewController.m
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import "BAMainViewController.h"
#import "BAAppDelegate.h"
@interface BAMainViewController ()

@end

@implementation BAMainViewController

int const seconds = 1.0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    _managedObjectContext = ((BAAppDelegate*)[app delegate]).managedObjectContext;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backgroundTask:(UIApplication*) app{
    NSLog(@"background fired");
}

- (IBAction)activateBackground:(id)sender{
    if (backgroundStarted){
        UIApplication* app = [UIApplication sharedApplication];
        [app endBackgroundTask:task];
        backgroundStarted = false;
        [self.timer invalidate];
        self.timer = nil;
        [self.locButton setTitle:@"Get my location, yo" forState:UIControlStateNormal];
    } else {
        UIApplication* app = [UIApplication sharedApplication];
        task = [app beginBackgroundTaskWithExpirationHandler:^{[self backgroundTask:app];}];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
        self->backgroundStarted = true;
        [self.locButton setTitle:@"Stop getting my location, Yo" forState:UIControlStateNormal];
    }
}

-(IBAction)endAdventure:(id)sender{
    
}

- (CLLocation*)getLocation {
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
    }
    [_locationManager startUpdatingLocation];
    sleep(1);
    CLLocation *loc = [_locationManager location];
    NSLog(@"loc: %@", [loc description]);
    [_locationManager stopUpdatingLocation];
    return loc;
}
@end
