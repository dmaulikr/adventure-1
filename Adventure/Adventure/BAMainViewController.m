//
//  BAMainViewController.m
//  Adventure
//
//  Created by Aaron Kawalsky on 12/16/12.
//  Copyright (c) 2012 Tal Levy. All rights reserved.
//

#import "BAMainViewController.h"
#import "BAAppDelegate.h"
#import "Location.h"
#import "Adventure.h"

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
    
	// Commit the change.
	NSError *error;
	if (![_managedObjectContext save:&error]) {
        NSLog(@"Error Error Error");
    }
    [_locationsArray insertObject:location atIndex:0];
    return loc;
}

//End the adventure?
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
}

@end
