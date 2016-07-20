//
//  Firebase.h
//  
//
//  Created by DetroitLabs on 7/19/16.
//
//

#import <Foundation/Foundation.h>
@import FirebaseDatabase;

@interface Firebase : NSObject
@property (nonatomic, strong) FIRDatabaseReference *ref;
@end
