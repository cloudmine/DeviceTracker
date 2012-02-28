//
//  KTViewController.m
//
//  Created by Marc Weil on 2/21/12.
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//

#import "DTViewController.h"

@implementation DTViewController

@synthesize mapView = _mapView;
@synthesize currentLocation = _currentLocation;

- (void)locationUpdated:(NSNotification *)notification {
    /*
     *****************************************************************
     **** Got a new location! Center the map at the new location
     **** and drop a pin there too.
     *****************************************************************
     */
    
    NSDictionary *userInfo = [notification.userInfo objectForKey:@"aps"];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[userInfo objectForKey:@"lat"] floatValue], [[userInfo objectForKey:@"lon"] floatValue]);
    
    [_mapView removeAnnotation:_currentLocation];
    
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    _currentLocation.coordinate = coord;
    
    [_mapView setRegion:newRegion animated:YES];
    [_mapView addAnnotation:_currentLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *pinReuseIdentifier = @"KidLocationPin";
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReuseIdentifier];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinReuseIdentifier];
        pin.animatesDrop = YES;
        pin.pinColor = MKPinAnnotationColorPurple;
        pin.canShowCallout = NO;
    }
    
    return pin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.showsUserLocation = YES;
    _currentLocation = [[MKPointAnnotation alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:@"LocationUpdated" object:nil];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
