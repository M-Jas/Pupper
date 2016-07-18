//
//  Dog.h
//  Pupper
//
//  Created by DetroitLabs on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject

@property (strong, nonatomic) NSString *dogName;
@property (strong, nonatomic) NSString *dogBreed;
@property (strong, nonatomic) NSString *dogAge;
@property (strong, nonatomic) NSString *dogAddress;
@property (strong, nonatomic) NSString *vetPhoneNumber;
@property (strong, nonatomic) NSString *dogBio;


- (instancetype)initWithDogName:(NSString *)name age:(NSString*)age breed:(NSString *)breed address:(NSString *)address vetPhoneNub:(NSString *)vetPhoneNum bio:(NSString *)bio;


@end