//
//  KTDeviceToken.h
//
//  Created by Marc Weil on 2/22/12.
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//

#import <CloudMine/CloudMine.h>

@interface DTDeviceToken : CMObject

@property (strong, readonly) NSString *token;

- (id)initWithTokenData:(NSData *)deviceToken;

@end