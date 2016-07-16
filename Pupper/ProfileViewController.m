//
//  ProfileViewController.m
//  Pupper
//
//  Created by DetroitLabs on 7/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *puppyNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *puppyAgeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *puppyBreedTextfield;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *vetPhoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextView *puppyBio;

@end


@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self profileEditing];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Button will activate all textfield and display save button
- (IBAction)editProfileButtonPressed:(id)sender {
    _puppyNameTextfield.userInteractionEnabled = YES;
    _puppyAgeTextfield.userInteractionEnabled = YES;
    _puppyBreedTextfield.userInteractionEnabled = YES;
    _userPhoneNumberTextfield.userInteractionEnabled = YES;
    _addressTextfield.userInteractionEnabled = YES;
    _vetPhoneNumberTextfield.userInteractionEnabled = YES;
    _puppyBio.userInteractionEnabled = YES;
    
    _saveButton.hidden = NO;

}

// Method to set all textfield to be disabled and save button hidden
- (void)profileEditing {
    _puppyNameTextfield.userInteractionEnabled = NO;
    _puppyAgeTextfield.userInteractionEnabled = NO;
    _puppyBreedTextfield.userInteractionEnabled = NO;
    _userPhoneNumberTextfield.userInteractionEnabled = NO;
    _addressTextfield.userInteractionEnabled = NO;
    _vetPhoneNumberTextfield.userInteractionEnabled = NO;
    _puppyBio.userInteractionEnabled = NO;
    
    _saveButton.hidden = YES;
    
    
}


- (IBAction)saveProfileButtonPressed:(id)sender {
    [self profileEditing];    
}


@end
