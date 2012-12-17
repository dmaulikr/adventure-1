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
        [self.locButton setTitle:@"Get my location, Yo" forState:UIControlStateNormal];
    } else {
        UIApplication* app = [UIApplication sharedApplication];
        task = [app beginBackgroundTaskWithExpirationHandler:^{[self backgroundTask:app];}];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
        self->backgroundStarted = true;
        [self.locButton setTitle:@"Stop getting my location, Yo" forState:UIControlStateNormal];
    }
}

-(IBAction)endAdventure:(id)sender{
    UIApplication* app = [UIApplication sharedApplication];
    [app endBackgroundTask:task];
    backgroundStarted = false;
    if (self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.locButton setTitle:@"Get my location, Yo" forState:UIControlStateNormal];
    
}

-(void)reverseGeocodeWithLoc:(CLLocation*) loc {
    double lat = [loc coordinate].latitude ;
    double lon = [loc coordinate].longitude;
    NSUInteger rad = 10;
    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%i&sensor=true&key=%@", lat, lon, rad, kG_API_KEY];
    
    NSURL* requestUrl = [NSURL URLWithString:url];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: requestUrl];
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data //1
                              options:kNilOptions
                              error:nil];
    });
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
    //[self reverseGeocodeWithLoc:loc];
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
	
	// Should be the location's timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
	[location setCreationDate:[NSDate date]];
	
	// Commit the change.
	NSError *error;
	if (![_managedObjectContext save:&error]) {
        NSLog(@"Error Error Error");
    }
    return loc;
}
@end
