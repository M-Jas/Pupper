//
//  Firebase.m
//  
//
//  Created by DetroitLabs on 7/19/16.
//
//

#import "Firebase.h"

@implementation Firebase

- (instancetype)init
{
    self = [super init];
    if (self) {
        _ref = [[FIRDatabase database] reference];
    }
    return self;
}

@end
