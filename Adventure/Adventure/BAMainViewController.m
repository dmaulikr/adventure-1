//
//  BAMainViewController.m
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import "BAMainViewController.h"
#import "BAAppDelegate.h"
#import "Adventure.h"
#include <math.h>

#define kG_API_KEY @"AIzaSyBreyyLHJ3ycs5M2TshR1x65SrWeDpmMAo"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


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
    
    [_locButton setEnabled:NO];
    [_locButton setAlpha:.5];
    
    [_endButton setEnabled:NO];
    [_endButton setAlpha:.5];
    
    UIApplication *app = [UIApplication sharedApplication];
    _managedObjectContext = ((BAAppDelegate*)[app delegate]).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:_managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
    // Set self's events array to the mutable array, then clean up.
	[self setLocationsArray:mutableFetchResults];
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
        [_endButton setEnabled:YES];
        [_endButton setAlpha:1];
    } else {
        UIApplication* app = [UIApplication sharedApplication];
        task = [app beginBackgroundTaskWithExpirationHandler:^{[self backgroundTask:app];}];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
        self->backgroundStarted = true;
        [self.locButton setTitle:@"Stop getting my location, Yo" forState:UIControlStateNormal];
        [_endButton setEnabled:NO];
        [_endButton setAlpha:.5];
    }
}

-(IBAction)endAdventure:(id)sender{
    [_locButton setEnabled:NO];
    [_locButton setAlpha:.5];
    
    [_endButton setEnabled:NO];
    [_endButton setAlpha:.5];
    
    [_startButton setEnabled:YES];
    [_startButton setAlpha:1];
    
    UIApplication* app = [UIApplication sharedApplication];
    [app endBackgroundTask:task];
    
}

- (IBAction)startAdventure:(id)sender {
    [_locButton setEnabled:YES];
    [_locButton setAlpha:1];
    
    [_startButton setEnabled:NO];
    [_startButton setAlpha:.5];
    if ([_locationsArray lastObject]) {
        advNum = [[[_locationsArray objectAtIndex:0] adventure] integerValue] + 1;
    }
    else
        advNum = 0;
    
    Adventure *adv = (Adventure *)[NSEntityDescription insertNewObjectForEntityForName:@"Adventure" inManagedObjectContext:_managedObjectContext];
    [adv setName:@"Generic Name"];
    [adv setNumber:[NSNumber numberWithInt:advNum]];
    
    // Commit the change.
	NSError *error;
	if (![_managedObjectContext save:&error]) {
        NSLog(@"Error Error Error");
    }
    backgroundStarted = false;
    if (self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.locButton setTitle:@"Get my location, Yo" forState:UIControlStateNormal];
    
}

- (CLLocation*)getLocation {
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
    }
    [_locationManager startUpdatingLocation];
    _locationManager.delegate = self;
    [_locationManager startMonitoringSignificantLocationChanges];
    sleep(1);
    CLLocation *loc = [_locationManager location];
    NSLog(@"loc: %@", [loc description]);
    [_locationManager stopUpdatingLocation];
    
    
    /*
	 Create a new instance of the Event entity.
	 */
	Location *location = (Location *)[NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];
    
	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = [loc coordinate];
	[location setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[location setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
    [location setAdventure:[NSNumber numberWithInt:advNum]];
	
	// Should be the location's timestamp, but this will be constant for simulator.
//	[location setCreationDate:[loc timestamp]];
	[location setCreationDate:[NSDate date]];
    
    void (^commitBlock)(Location*, NSData*) = ^(Location* loc, NSData* data){
        loc.jsonData = data;
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error Error Error");
        }
        [_locationsArray insertObject:location atIndex:0];
    };
    Location *loc1 = (Location*)[_locationsArray objectAtIndex:0];
    if ([self isSignificantDistance:loc1 and:location]) {
        [self reverseGeocodeWithLoc:location andBlock:commitBlock];
    }
	// Commit the change.
    return loc;
}

-(void)reverseGeocodeWithLoc:(Location*) loc andBlock:(void(^)(Location*, NSData*)) block {
    double lat = [[loc latitude] doubleValue];
    double lon = [[loc longitude] doubleValue];
    NSLog(@"Long = %f, Lat = %f", lon, lat);
    NSUInteger rad = 10;
    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%i&sensor=true&key=%@", lat, lon, rad, kG_API_KEY];
    
    NSURL* requestUrl = [NSURL URLWithString:url];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: requestUrl];
        
        block(loc, data);
    });
}

- (BOOL)isSignificantDistance:(Location*)loc1 and:(Location*)otherLoc {
    double R = 6371; // km
    double dLat = ([otherLoc.latitude doubleValue]-[loc1.latitude doubleValue]) * M_PI / 180.0;
    double dLon = ([otherLoc.longitude doubleValue]-[loc1.longitude doubleValue]) * M_PI / 180.0;
    double lat1 = [loc1.latitude doubleValue] * M_PI / 180.0;
    double lat2 = [otherLoc.latitude doubleValue] * M_PI / 180.0;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = R * c;
    NSLog(@"The distance Between the points in meters is %.10f", d);
    return d > 10.0;
}
@end
