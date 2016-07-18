//
//  User.m
//  Pupper
//
//  Created by DetroitLabs on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "User.h"

@implementation User


- (instancetype)initWithEmail:(NSString *)email phoneNumber:(NSString *)phone {
    self = [super init];
    if (self) {
        _userEmail = email;
        _userPhoneNumber = phone;
    }
    return self;
}

@end
