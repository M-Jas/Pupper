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
        //Need to add the array here to keep it from Crashing
        [upcomingServicesArray removeObjectAtIndex: indexPath.row];
        [_mainDisplayUpcomingServices deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
}

- (IBAction)unwindForBookingSegue:(UIStoryboardSegue *)unwindSegue {
    BookingViewController *vc = [unwindSegue sourceViewController];
//    upcomingServicesArray = vc.servicesOnSelectedDate;
    
    NSLog(@"The date you selected %@", upcomingServicesArray);
    
}

- (IBAction)bookServiceButtonPressed:(id)sender {
//    [self presentViewController: animated:YES completion:nil];
}

- (NSMutableArray *)testingTVMethod {
    upcomingServicesArray = [[NSMutableArray alloc] initWithObjects:@"Johnny 5", @"Zero Cool", nil];
    
    return upcomingServicesArray;
}

@end
