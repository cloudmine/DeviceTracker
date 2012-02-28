//
//  KTAppDelegate.m
//
//  Created by Marc Weil on 2/21/12.
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//

#import "DTAppDelegate.h"
#import "DTDeviceToken.h"

@implementation DTAppDelegate {
    CMStore *store;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     ***************************************
     **** Configure CloudMine credentials. **
     ****************************************
     */
     
    [[CMAPICredentials sharedInstance] setAppIdentifier:@"83e145d117db4aef9c399808c54e1672"];
    [[CMAPICredentials sharedInstance] setAppSecret:@"6ce718b3781c47c79373aee39816e560"];
    
    /*
     ******************************************************************************
     **** Ask user for permission to push notifications to the app.
     *******************************************************************************
     */
    [[UIApplication sharedApplication] 
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // Check if the launch was as a result of a push notification and handle it appropriately if so.
    NSDictionary *apsDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (apsDict) {
        void (^noteBlock)(NSDictionary *) = ^(NSDictionary *userInfo) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdated" object:self userInfo:userInfo];
        };
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:noteBlock, @"block", apsDict, @"blockOptions", nil];
        [self performSelector:@selector(performBlockContainedInOptions:)
                   withObject:options
                   afterDelay:1.0
                      inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    }
    
    
    if (!store) {
        store = [CMStore store];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    DTDeviceToken *token = [[DTDeviceToken alloc] initWithTokenData:deviceToken];
    
    /*
     ******************************************************************************
     **** Check to see if the device has already been registered.
     *******************************************************************************
     */    
    
    [store allObjectsOfType:[DTDeviceToken class] additionalOptions:nil callback:^(NSArray *objects, NSDictionary *errors) {
        NSUInteger tokenIdx = [objects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [token.token isEqualToString:[obj token]];
        }];
        
        if (tokenIdx == NSNotFound) {
            [self registerDeviceToken:token];
        }
    }];
}

- (void)registerDeviceToken:(DTDeviceToken *)token {
    
    /*
     ****************************************************
     **** Options required to call server-side function
     **** that will register device with Urban Airship
     ****************************************************
     */
    
    CMServerFunction *function = [CMServerFunction serverFunctionWithName:@"registerDevice" 
                                                          extraParameters:
                                  [NSDictionary dictionaryWithObject:token.token forKey:@"device_token"]
                                               responseContainsResultOnly:YES];
    
    CMStoreOptions *storeOptions = [[CMStoreOptions alloc] initWithServerSideFunction:function];
    
    /*
     *****************************************************************
     **** Save the token to CloudMine and register with Urban Airship
     *****************************************************************
     */
    
    [store saveObject:token additionalOptions:storeOptions callback:^(NSDictionary *uploadStatuses) {
        if (store.lastError) {
            NSLog(@"Ruh roh! There was an error. %@", [store.lastError description]);
        } else {
            NSLog(@"Token registered successfully");
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdated" object:self userInfo:userInfo];
}

- (void)performBlockContainedInOptions:(NSDictionary *)options {
    void (^block)(NSDictionary *dict) = [options objectForKey:@"block"];
    block([options objectForKey:@"blockOptions"]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for push notifications! Error: %@", [error description]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
