//
//  Service.h
//  Pupper
//
//  Created by DetroitLabs on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firebase.h"

@import Firebase;

@interface Service : NSObject

@property (strong, nonatomic) NSString *selectedService;
@property (strong, nonatomic) NSNumber *priceOfService;
@property (strong, nonatomic) NSString *dateOfService;
@property (strong, nonatomic) NSString *currentUserID;

- (instancetype)initWithService:(NSString *)service dateOfService:(NSString *)date priceOfService:(NSNumber *)servicePrice userID:(NSString *)userId;

@end
