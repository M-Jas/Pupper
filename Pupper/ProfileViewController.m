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
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadPhotoButton;

@property (weak, nonatomic) IBOutlet UITextField *puppyNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *puppyAgeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *puppyBreedTextfield;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *vetPhoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextView *puppyBio;

@property (strong, nonatomic) IBOutlet UIImageView *dogProfileImage;

@end

Dog *newDog;

@implementation ProfileViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];

        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        [super viewDidLoad];
 
    [self profileEditingNotSelected];
    
    
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
- (void)profileEditingNotSelected {
    
    _puppyNameTextfield.userInteractionEnabled = NO;
    _puppyAgeTextfield.userInteractionEnabled = NO;
    _puppyBreedTextfield.userInteractionEnabled = NO;
    _userPhoneNumberTextfield.userInteractionEnabled = NO;
    _addressTextfield.userInteractionEnabled = NO;
    _vetPhoneNumberTextfield.userInteractionEnabled = NO;
    _puppyBio.userInteractionEnabled = NO;
    
    _saveButton.hidden = YES;
    _takePhotoButton.hidden = YES;
    _uploadPhotoButton.hidden = YES;
    
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
    _takePhotoButton.hidden = NO;
    _uploadPhotoButton.hidden = NO;

}



- (IBAction)saveProfileButtonPressed:(id)sender {
    [self profileEditingNotSelected];
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
- (IBAction)takePhotoButtonPress:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)uploadPhotoButtonPress:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _dogProfileImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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


//-(void)presentCamera {
//   UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
//    [imagePicker setDelegate:self];
//    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    //    NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
//    //    _imagePicker.mediaTypes = mediaTypes;
//    [self presentViewController:imagePicker animated:true completion:nil];
//}

- (IBAction)takePhotoButtonPressed:(id)sender {
}

@end
