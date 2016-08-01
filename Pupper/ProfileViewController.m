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
#import "Cloudinary/Cloudinary.h"

@interface ProfileViewController () <CLUploaderDelegate>

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

@property (strong, nonatomic) UIImagePickerController *picker;

@end

Dog *newDog;

@implementation ProfileViewController

- (void)viewDidLoad {
    
        // Alert is camera is not aviliable on device!!!!!!CHANGE THIS LATER
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
    _currentUser = [[User alloc]init];
    
    [self retriveServicesFromFBDB];
    
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

// Method to set all textfield to be disabled and save button hidden***************************************************************
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

// Button will activate all textfield and display save button**********************************************************************
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
    
    _picker = [[UIImagePickerController alloc] init];

}

// Saving all the new information added by the user******************************************************************************
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
    
    newDog = [[Dog alloc]initWithDogName:name age:age breed:breed address:address vetPhoneNub:vetPhoneNum bio:bio userID:[FIRAuth auth].currentUser.uid];
    
    [self addDogToDB:newDog];
    [self sendImageToCloudinary];
}

// Camera Actions***************************************************************************************************************
- (IBAction)takePhotoButtonPress:(id)sender {
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:_picker animated:YES completion:NULL];
}

- (IBAction)uploadPhotoButtonPress:(id)sender {
//    UIImagePickerController *picker
//    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _dogProfileImage.image = chosenImage;
    
    [_picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_picker dismissViewControllerAnimated:YES completion:NULL];
}



// Send new Dog Info to FireBase***************************************************************************************************

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
                              @"bio": dog.dogBio,
                              @"userID": dog.currentUserID
                              };
    [dogRef setValue:dogDict];
}

// Pull dog info from Firebase*******************************************************************************************************
- (void)retriveServicesFromFBDB {
    // Ref to the main Database
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    
    // Query is going to the service child and looking over the user IDs to find the current users services
    FIRDatabaseQuery *query = [[[firebaseRef child:@"dogs"] queryOrderedByChild:@"userID"]queryEqualToValue:[FIRAuth auth].currentUser.uid];
    
    // FIRDataEventTypeChildAdded event is triggered once for each existing child and then again every time a new child is added to the specified path.
    [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        // Use snapshot to create a new service"
        Dog *currentUserDog = [[Dog alloc]initWithDogName:snapshot.value[@"name"] age:snapshot.value[@"age"] breed:snapshot.value[@"breed"] address:snapshot.value[@"address"] vetPhoneNub:snapshot.value[@"vet"] bio:snapshot.value[@"bio"] userID:snapshot.value[@"userID"]];
        NSLog(@"my dog: %@", currentUserDog.dogName);
        
        _puppyNameTextfield.text = currentUserDog.dogName;
        _puppyAgeTextfield.text = currentUserDog.dogAge;
        _puppyBreedTextfield.text = currentUserDog.dogBreed;
        //Might not need this to tie the dog to a user
        
        _addressTextfield.text = currentUserDog.dogAddress;
        _vetPhoneNumberTextfield.text = currentUserDog.vetPhoneNumber;
        _puppyBio.text = currentUserDog.dogBio;
        
        
        // Add services from db to user array to display on pageload
//        [_currentUser.userDogsArray addObject:currentUserDog];
//        NSLog(@"user dog array: %@", _currentUser.userDogsArray);
        
    }];
    
}


//SENDING IMAGE TO CLOUDINARY DB*****************************************************************************************************

// CLUploaderDelegate protocol for receiving successful
- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
    NSString* publicId = [result valueForKey:@"public_id"];
    NSLog(@"Upload success. Public ID=%@, Full result=%@", publicId, result);
}

// CLUploaderDelegate protocol for receiving unsuccessful
- (void) uploaderError:(NSString*)result code:(int)code context:(id)context {
    NSLog(@"Upload error: %@, %d", result, code);
}

// CLUploaderDelegate protocol for receiving progress of upLoad
- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
    NSLog(@"Upload progress: %ld/%ld (+%ld)", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, (long)bytesWritten);
}

- (void) sendImageToCloudinary {
    // Creation of Cloudinary Object
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    //Safe mobile uploading
    [cloudinary.config setValue:@"dolhcgb0l" forKey:@"cloud_name"];
    // Create uploding method to cloudinary
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    // Turn the photo into nsdata to return to the db
    NSData *imageData = UIImagePNGRepresentation(_dogProfileImage.image);
    
    // Upload method to db using the unsigned image preset rm17j02k. The options are how I can change the image as it is sent
    [uploader unsignedUpload:imageData uploadPreset:@"rm17j02k" options:@{}];
    
}
@end
