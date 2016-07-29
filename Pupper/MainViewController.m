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
@import Firebase;


@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainDisplayUpcomingServices;

@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) UIImage *sample;

@end



@implementation MainViewController

NSMutableArray *upcomingServicesArray;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self testingTVMethod];
    [self cloudinarySetUp];
    
  
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    self.title = @"Puppy Main Page";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

// Cloudinary setup to pull images from the DB*****************************************************************************************
-   (void)cloudinarySetUp {
    //Setup
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configuration = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *clientId = configuration[@"Cloudinary"][@"ClientID"];
    NSString *clientSecret = configuration[@"Cloudinary"][@"ClientSecret"];
    
    // Create Cloudinary Object
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    
    // Set cloudinary obj with plist
    [cloudinary.config setValue:@"dolhcgb0l" forKey:@"cloud_name"];
    [cloudinary.config setValue:clientId forKey:@"api_key"];
    [cloudinary.config setValue:clientSecret forKey:@"api_secret"];
    
    // String of the image to be shown from db with Clodinary method
    NSString *urlCloud = [cloudinary url:@"sample.png"];
    // Create NSURL
    NSURL *url = [NSURL URLWithString:urlCloud];
    // Set date with the URL
    NSData *data = [NSData dataWithContentsOfURL:url];
    // Turn the data into an image
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    // Set main imageView to picture from the database
    _mainImage.image = tmpImage;

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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//Delete method for Tableview used and Tablevie is adjusted with remaining objects in the array********************************************************
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [upcomingServicesArray removeObjectAtIndex: indexPath.row];
        [_mainDisplayUpcomingServices deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
}

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
    //vc.userServicesArray = _currentUser.userServicesArray;
    vc.currentUser = _currentUser;
    NSLog(@"%@", vc.currentUser);
//    NSLog(@"%@", vc.userServicesArray);
}



- (NSMutableArray *)testingTVMethod {
    upcomingServicesArray = [[NSMutableArray alloc] initWithObjects:@"Johnny 5", @"Zero Cool", nil];
    
    return upcomingServicesArray;
}

//Create new user and Sign in features****************************************************************
- (IBAction)signupNewUserPress:(id)sender {
    [self createUserAlert];
}

- (IBAction)signInUserPress:(id)sender {
    [self signInUserAlert];
}

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
                         }];
}

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
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
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
        textField.placeholder = @"Email";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



@end
