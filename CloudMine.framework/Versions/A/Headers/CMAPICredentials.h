//
//  CMAPICredentials.h
//  cloudmine-ios
//
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import <Foundation/Foundation.h>

/**
 * Convenience singleton class for storing your API key and this app's secret key
 * for communicating with CloudMine web services. If this is configured you do not have to pass either of these
 * strings to the web service methods.
 */
@interface CMAPICredentials : NSObject

/**
 * @return The shared instance of this object.
 */
+ (id)sharedInstance;

/**
 * The Secret Key from your CloudMine dashboard.
 * @see https://cloudmine.me/dashboard
 */
@property (strong) NSString *appSecret;

/**
 * The App Identifier from your CloudMine dashboard.
 * @see https://cloudmine.me/dashboard
 */
@property (strong) NSString *appIdentifier;

@end
