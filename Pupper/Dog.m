//
//  Dog.m
//  Pupper
//
//  Created by DetroitLabs on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Dog.h"

@implementation Dog

- (instancetype)initWithDogName:(NSString *)name age:(NSString*)age breed:(NSString *)breed address:(NSString *)address vetPhoneNub:(NSString *)vetPhoneNum bio:(NSString *)bio {
    self = [super init];
    if (self) {
        _dogName = name;
        _dogAge = age;
        _dogBreed = breed;
        _dogAddress = address;
        _vetPhoneNumber = vetPhoneNum;
        _dogBio = bio;
    }
    return self;
}

@end
