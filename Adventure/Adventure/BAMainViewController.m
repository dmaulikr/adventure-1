//
//  BAMainViewController.m
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import "BAMainViewController.h"

@interface BAMainViewController ()

@end

@implementation BAMainViewController

int const seconds = 10;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backgroundTask:(UIApplication*) app{
    NSTimer* backgroundTimer = [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
    [backgroundTimer fire];
}

- (IBAction)activateBackground:(id)sender{
    UIApplication* app = [UIApplication sharedApplication];
    [app beginBackgroundTaskWithExpirationHandler:^{[self backgroundTask:app];}];
}

- (IBAction)getLocation:(id)sender {
    if (!locationManager)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
    }
    [locationManager startUpdatingLocation];
    sleep(1);
    CLLocation *loc = [locationManager location];
    NSLog(@"loc: %@", [loc description]);
    [locationManager stopUpdatingLocation];
}
@end
