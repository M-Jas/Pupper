//
//  Service.m
//  Pupper
//
//  Created by DetroitLabs on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Service.h"

@implementation Service

- (instancetype)initWithService:(NSString *)service dateOfService:(NSString *)date priceOfService:(NSNumber *)servicePrice userID:(NSString *)userId{
    self = [super init];
    if (self) {
        _selectedService = service;
        _dateOfService = date;
        _priceOfService = servicePrice;
        _currentUserID = userId;
        _serviceID = [[NSUUID UUID]UUIDString];
    }
    return self;
}

@end
