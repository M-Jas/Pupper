//
//  PhotoControllerViewController.h
//  Pupper
//
//  Created by DetroitLabs on 7/19/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoControllerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *photoUIVIew;

- (IBAction)takePhotoButton:(id)sender;

- (IBAction)uploadButton:(id)sender;

@end
