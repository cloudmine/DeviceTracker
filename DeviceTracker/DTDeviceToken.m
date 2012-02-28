//
//  KTDeviceToken.m
//
//  Created by Marc Weil on 2/22/12.
//  Copyright (c) 2012 CloudMine, LLC. All rights reserved.
//

#import "DTDeviceToken.h"

@implementation DTDeviceToken

@synthesize token;

- (id)initWithTokenData:(NSData *)deviceToken {
    if (self = [super init]) {
        token = [[[[[deviceToken description]
                                            stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                           stringByReplacingOccurrencesOfString: @">" withString: @""]
                                          stringByReplacingOccurrencesOfString: @" " withString: @""]
                                         uppercaseString];
        NSLog(@"APS token is %@", self.token);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:token forKey:@"token"];
}

@end
