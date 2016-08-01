//
//  User.m
//  Pupper
//
//  Created by DetroitLabs on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "User.h"

@implementation User


- (instancetype)initWithEmail:(NSString *)email userPassword:(NSString *)password {
    self = [super init];
    if (self) {
        _userEmail = email;
        _userPassword = password;
        _userServicesArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
