//
//  KTAppDelegate.h
//
//  Created by Marc Weil on 2/21/12.
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTDeviceToken;

@interface DTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)performBlockContainedInOptions:(NSDictionary *)options;
- (void)registerDeviceToken:(DTDeviceToken *)token;

@end
