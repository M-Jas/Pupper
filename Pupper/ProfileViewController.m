//
//  ProfileViewController.m
//  Pupper
//
//  Created by DetroitLabs on 7/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

@import FirebaseDatabase;
@import FirebaseStorage;
@import FirebaseDatabase;

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "Dog.h"

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

Dog *newDog;

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



- (IBAction)saveProfileButtonPressed:(id)sender {
    [self profileEditing];
    NSString *name = _puppyNameTextfield.text;
    NSString *age = _puppyAgeTextfield.text;
    NSString *breed =_puppyBreedTextfield.text;
    //Might not need this to tie the dog to a user
    NSString *userPhoneNum =_userPhoneNumberTextfield.text;
    NSString *address = _addressTextfield.text;
    NSString *vetPhoneNum = _vetPhoneNumberTextfield.text;
    NSString *bio = _puppyBio.text;
    
    newDog = [[Dog alloc]initWithDogName:name age:age breed:breed address:address vetPhoneNub:vetPhoneNum bio:bio];
    
    
    [self addDogToDB:newDog];
}


- (void)addDogToDB:(Dog *)dog {
    //Create reference to the firebase database
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    
    //Use the reference from above to add a child to that db as a "group"
    FIRDatabaseReference *dogRef = [[firebaseRef child:@"dogs"] childByAutoId];
    
    //The dict is going to be the way to structure the database
    //Need to add in the user id once that is created to tie relationship
    //Need to add user and user phone number
    NSDictionary *dogDict = @{
                              @"name": dog.dogName,
                              @"age": dog.dogAge,
                              @"breed": dog.dogBreed,
                              @"address": dog.dogAddress,
                              @"vet": dog.vetPhoneNumber,
                              @"bio": dog.dogBio
                              };
    [dogRef setValue:dogDict];
}


@end
