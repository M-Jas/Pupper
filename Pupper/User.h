//
//  User.h
//  Pupper
//
//  Created by DetroitLabs on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"
#import "Service.h"

@interface User : NSObject

@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userPhoneNumber;
@property (strong, nonatomic) NSMutableArray *userDogsArray;
@property (strong, nonatomic) NSMutableArray *userServicesArray;

@property (strong, nonatomic) Dog *dog;
@property (strong, nonatomic) Service *service;


- (id)initWithEmail:(NSString *)email phoneNumber:(NSString *)phone;


@end
