//
//  KTViewController.h
//
//  Created by Marc Weil on 2/21/12.
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPointAnnotation *currentLocation;

- (void)locationUpdated:(NSNotification *)notification;

@end
