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

- (instancetype)initWithService:(NSString *)service priceOfService:(NSNumber *)servicePrice;


@end
