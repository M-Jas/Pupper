//
//  ViewController.m
//  Pupper
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "BookingViewController.h"
#import "Cloudinary/Cloudinary.h"
#import "Firebase.h"
#import "User.h"
#import "Dog.h"


@import Firebase;


@interface MainViewController ()
@property (strong, nonatomic) UIImage *sample;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;

@property (weak, nonatomic) IBOutlet UITableView *mainDisplayUpcomingServices;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *signOutButton;

@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *bookPupperButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;

@end



@implementation MainViewController

NSMutableArray *upcomingServicesArray;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self testingTVMethod];
    [self initalCloudinarySetUp];
    [self drawerMethod];
    [self buttonsStyle];
    
    _bookPupperButton.hidden = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:239.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0];
    [self changeBarButtonVisibility:self.navigationItem.rightBarButtonItems[0] visibility:NO];
  
    [self imageDesign];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



// Tableview size and setup to display information*******************************************************************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [upcomingServicesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath:indexPath];
    NSString *testString = [upcomingServicesArray objectAtIndex:indexPath.row];
 
    cell.textLabel.text = testString;
    
    return cell;
    
}




//Display Delete method for TableView*******************************************************
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}

//Delete method for Tableview used and Tablevie is adjusted with remaining objects in the array********************************************************
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [upcomingServicesArray removeObjectAtIndex: indexPath.row];
//        [_mainDisplayUpcomingServices deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
//    }
//}

//- (IBAction)unwindForBookingSegue:(UIStoryboardSegue *)unwindSegue {
//    BookingViewController *vc = [unwindSegue sourceViewController];
////    upcomingServicesArray = vc.servicesOnSelectedDate;
//    NSLog(@"The date you selected %@", upcomingServicesArray);
//
//}

- (IBAction)bookServiceButtonPressed:(id)sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BookingViewController *vc = [segue destinationViewController];

    vc.currentUser = _currentUser;
    NSLog(@"%@", vc.currentUser);

}



- (NSMutableArray *)testingTVMethod {
    upcomingServicesArray = [[NSMutableArray alloc] initWithObjects:@"Johnny 5", @"Zero Cool", nil];
    
    return upcomingServicesArray;
}

//Create new user and Sign in/out features****************************************************************
- (IBAction)signupNewUserPress:(id)sender {
    [self createUserAlert];
}

- (IBAction)signInUserPress:(id)sender {
    [self signInUserAlert];
}

- (IBAction)signOutPressed:(id)sender {
    [self signOutFirebase];
    
}


// ALerts *****************************************************************************************************
- (void) createUserAlert {
    UIAlertController * alert =   [UIAlertController
                                  alertControllerWithTitle:@"Welcome to Pupper"
                                  message:@"Please Enter The Following Information"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* create = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       NSString *email = [[[alert textFields]firstObject]text];
                                                       NSString *password = [[[alert textFields]firstObject]text];
                                                       //Create a new user object if all the info works
                                                       _currentUser = [[User alloc] initWithEmail:email userPassword:password];
                                                       //Send user firebase auth
                                                       [self createNewUser:email password:password];
                                                   }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:create];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email";
//        textField.text = @"j@gmail.com";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.text = @"tort";
        textField.secureTextEntry = YES;
    }];
    
    
    [self presentViewController:alert animated:YES completion:nil];

}


- (void) signInUserAlert {
    NSLog(@"Working");
    UIAlertController * alert =   [UIAlertController
                                  alertControllerWithTitle:@"Welcome to Back"
                                  message:@"Please Enter Your Credentials"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* signIn = [UIAlertAction actionWithTitle:@"signIn" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       //confrim if info provided by the user is correct and log them in
                                                       NSString *email = [[[alert textFields]firstObject]text];
                                                       NSString *password = [[[alert textFields]firstObject]text];
                                                       //Create a new user object if all the info works
                                                       _currentUser = [[User alloc] initWithEmail:email userPassword:password];
                                                       
                                                       [self signInUser:email password:password];
                                                       
                                                   }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:signIn];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Email";
        textField.text = @"j@gmail.com";
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Password";
        textField.text = @"tort";
        textField.secureTextEntry = YES;
    }];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

// Creat and Sign In/out Methods to Firebase**********************************************************************
-(void)createNewUser:(NSString *)email password:(NSString *)password {
    [[FIRAuth auth]
     createUserWithEmail:email
     password: password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
     }];
}

- (void) signInUser:(NSString *)email password:(NSString *)password {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             NSLog(@"%@, %@" ,user.description, error);
                             if (user.description != nil){
                                 [self dogImageURL];
                                 [self changeBarButtonVisibility:self.navigationItem.rightBarButtonItems[0] visibility:YES];
                                 _bookPupperButton.hidden = NO;
                                 _signInButton.hidden = YES;
                                 _signupButton.hidden = YES;
                             }
                         }];
}

- (void) signOutFirebase {
    FIRAuth *firebaseAuth = [FIRAuth auth];
    NSError *signOutError;
    
    BOOL status = [firebaseAuth signOut:&signOutError];
    if (!status) {
        NSLog(@"ERROR Signing Out: %@", signOutError);
        return;
    } else {
        NSLog(@"SIgned OUT");
        [self changeBarButtonVisibility:self.navigationItem.rightBarButtonItems[0] visibility:NO];
        [self initalCloudinarySetUp];
        _bookPupperButton.hidden = YES;
        _signInButton.hidden = NO;
        _signupButton.hidden = NO;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// Cloudinary setup to pull images from the DB*****************************************************************************************
-   (void)initalCloudinarySetUp {
    //Setup
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configuration = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *clientId = configuration[@"Cloudinary"][@"ClientID"];
    NSString *clientSecret = configuration[@"Cloudinary"][@"ClientSecret"];
    
    // Create Cloudinary Object
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    
    [cloudinary.config setValue:@"dolhcgb0l" forKey:@"cloud_name"];
    [cloudinary.config setValue:clientId forKey:@"api_key"];
    [cloudinary.config setValue:clientSecret forKey:@"api_secret"];
    
    // String of the image to be shown from db with Clodinary method
    NSString *urlCloud = [cloudinary url:@"1_rviwga.jpg"];
    // Create NSURL
    NSURL *url = [NSURL URLWithString:urlCloud];
    // Set date with the URL
    NSData *data = [NSData dataWithContentsOfURL:url];
    // Turn the data into an image
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    // Set main imageView to picture from the database
    _mainImage.image = tmpImage;
    
}

-(void)dogImageURL{
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    
    // Query is going to the service child and looking over the user IDs to find the current users services
    FIRDatabaseQuery *query = [[[firebaseRef child:@"dogs"] queryOrderedByChild:@"userID"]queryEqualToValue:[FIRAuth auth].currentUser.uid];
    
    
    [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        // Use snapshot to create a new service"
        Dog *userDog = [[Dog alloc]init];
        userDog.urlPath = snapshot.value[@"photoURL"];
        
        [self userDogImageFromCloudinary:userDog.urlPath];
        
    }];
}
- (void)userDogImageFromCloudinary:(NSString *)profileURL {

 
    // Create Cloudinary Object
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    
    // Set cloudinary obj with plist
    [cloudinary.config setValue:@"dolhcgb0l" forKey:@"cloud_name"];
    
    // String of the image to be shown from db with Clodinary method
    NSString *urlCloud = [cloudinary url: profileURL];
    // Create NSURL
    NSURL *url = [NSURL URLWithString:urlCloud];
    // Set date with the URL
    NSData *data = [NSData dataWithContentsOfURL:url];
    // Turn the data into an image
    UIImage *dogImage = [[UIImage alloc] initWithData:data];
    // Set dog profile pick from db photo
    _mainImage.image = dogImage;
    
}

// Style and layouts**************************************************************************************************
- (void)drawerMethod{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void) changeBarButtonVisibility:(UIBarButtonItem*) barButtonItem visibility:(BOOL) shouldShow {
    UIColor *tintColor = shouldShow == NO ? [UIColor clearColor] : nil;
    [barButtonItem setEnabled:shouldShow];
    [barButtonItem setTintColor:tintColor];
    
}


- (void)imageDesign {
    self.mainImage.layer.cornerRadius = self.mainImage.frame.size.width / 2;
    self.mainImage.clipsToBounds = YES;
    
    self.mainImage.layer.borderWidth = 3.0f;
    self.mainImage.layer.borderColor = [UIColor colorWithRed:239.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0].CGColor;
}


- (void)buttonsStyle {
    _signInButton.layer.cornerRadius = 15;
    _signInButton.layer.borderColor = [UIColor colorWithRed:239.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0].CGColor;
    _signInButton.layer.borderWidth = 2.0f;
    
    _signupButton.layer.cornerRadius = 15;
    _signupButton.layer.borderColor = [UIColor colorWithRed:239.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0].CGColor;
    _signupButton.layer.borderWidth = 2.0f;
    
    _bookPupperButton.layer.cornerRadius = 15;
    _bookPupperButton.layer.borderColor = [UIColor colorWithRed:239.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0].CGColor;
    _bookPupperButton.layer.borderWidth = 2.0f;
    
}

@end
