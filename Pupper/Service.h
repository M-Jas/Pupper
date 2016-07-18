//
//  Service.h
//  Pupper
//
//  Created by DetroitLabs on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject

@property (strong, nonatomic) NSString *selectedService;
@property (strong, nonatomic) NSNumber *priceOfService;
@property (strong, nonatomic) NSString *dateOfService;

- (instancetype)initWithService:(NSString *)service dateOfService:(NSString *)date priceOfService:(NSNumber *)servicePrice;


@end
