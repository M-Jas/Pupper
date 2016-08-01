//
//  ProfileViewController.h
//  Pupper
//
//  Created by DetroitLabs on 7/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) User *currentUser;

@end
