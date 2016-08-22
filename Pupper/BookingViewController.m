//
//  BookingViewController.m
//  Pupper
//
//  Created by DetroitLabs on 7/13/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//


@import FirebaseDatabase;
@import FirebaseStorage;
@import FirebaseDatabase;
#import "BookingViewController.h"
#import "SWRevealViewController.h"
#import "Service.h"
#import "User.h"
#import "Firebase.h"



@interface BookingViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *upcomingServicesTableView;

@property (strong , nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSString *dateString;

@end

NSString *key;


@implementation BookingViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [_currentUser.userServicesArray removeAllObjects];
    [self retrieveServicesFromFBDB];
//    [self drawerMethod];
    
    NSLog(@"BEEEEEEBOOOOOOOO");
    [self setTableviewColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
     [_currentUser.userServicesArray removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

// clicking on a date adds a string of "yyyy/MM/dd" into an array which is called to populate the tableview
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    _dateString =[calendar stringFromDate:date format:@"yyyy/MM/dd"];
     [self serviceAlert];
    
}


- (void)serviceAlert {
                                                                  [_currentUser.userServicesArray removeAllObjects];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Service Options"
                                                                   message:@"Please select a service for Puppy"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
   UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Walk"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

                                                              _service = [[Service alloc]initWithService:@"Walk" dateOfService:_dateString priceOfService:[NSNumber numberWithDouble:10.00] userID:[FIRAuth auth].currentUser.uid];

                                                              //Add service obj to users array for services
                                                              //*****SO if I add this here I'm double doing it to the user array????????????????
//                                                              [_currentUser.userServicesArray addObject:_service];
                                                              //Add service obj to FireBase
                                                               NSLog(@"Array COUNT ALERT 1: %lu", [_currentUser.userServicesArray count]);
                                                              [_currentUser.userServicesArray removeAllObjects];
                                                               NSLog(@"Array COUNT ALERT 2: %lu", [_currentUser.userServicesArray count]);
                                                              [self addServiceToDB:_service];
                                                               NSLog(@"Array COUNT ALERT 3: %lu", [_currentUser.userServicesArray count]);
                                                              
                                                              
                                                              //Reload table after click
//                                                              [_upcomingServicesTableView reloadData];
                                                          }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Feeding"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           
                                                               _service = [[Service alloc]initWithService:@"Feeding" dateOfService:_dateString priceOfService:[NSNumber numberWithDouble:5.00] userID:[FIRAuth auth].currentUser.uid];
                                                               //Add service obj to users array for services
//                                                               [_currentUser.userServicesArray addObject:_service];
                                                               //Add service obj to FireBase
                                                               [self addServiceToDB:_service];
                                                               //Reload table after click
//                                                               [_upcomingServicesTableView reloadData];
                                                           }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

// ADD TO TABLE VIEW****************************************************************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"COUNT OF ARRAY: %lu", [_currentUser.userServicesArray count]);
    return [_currentUser.userServicesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath:indexPath];
    Service *newService = [_currentUser.userServicesArray objectAtIndex: indexPath.row];
    NSString *newDate = newService.dateOfService;
    NSString *newSelectedService = newService.selectedService;
    
    cell.textLabel.textColor = [UIColor colorWithRed:239.0/255.0 green:195.0/255.0 blue:45.0/255.0 alpha:1.0];
    cell.textLabel.text = newDate;
    cell.detailTextLabel.text = newSelectedService;
    
    return cell;
    
}


//Display Delete method for TableView*******************************************************
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//Delete method for Tableview used and Tableview is adjusted with remaining objects in the array********************************************************
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Need to add the array here to keep it from Crashing
        [_currentUser.userServicesArray removeObjectAtIndex: indexPath.row];
        [_upcomingServicesTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];

        [self removeServiceFromDB];
    }
}

// Database methods *************************************************************************
- (void)removeServiceFromDB {
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    NSDictionary *childUpdates = @{[@"/services/" stringByAppendingString: key]:[NSNull null]};
    
    [firebaseRef updateChildValues: childUpdates];
}


- (void)addServiceToDB:(Service *)service {
    //Create reference to the firebase database
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    //Use the reference from above to add a child to that db as a "group"
    
    //The dict is going to be the way to structure the database
    //Need to add in the user id once that is created to tie relationship
    NSDictionary *serviceDict = @{
                                  
                                          service.serviceID: @{
                                            @"selectedService": service.selectedService,
                                            @"dateOfService": service.dateOfService,
                                            @"costOfService": service.priceOfService
                                            }
                                
                                  };
    
    [[[firebaseRef child:@"services"] child:service.currentUserID] updateChildValues: serviceDict];
//    [serviceRef setValue:serviceDict];
}

- (void)retrieveServicesFromFBDB {
    NSLog(@"CALLLLLLL");
    // Ref to the main Database
//    [_currentUser.userServicesArray removeAllObjects];
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];

    // Query is going to the service child and looking over the user IDs to find the current users services
    FIRDatabaseQuery *query = [[firebaseRef child:@"services"]child:[FIRAuth auth].currentUser.uid];
//                                queryOrderedByChild:@"userID"]queryEqualToValue:[FIRAuth auth].currentUser.uid];
    
    // FIRDataEventTypeChildAdded event is triggered once for each existing child and then again every time a new child is added to the specified path.
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        // Use snapshot to create a new service"
        NSLog(@"SNAPSHOT: %@", snapshot.value);
//        Service *dbServices = [[Service alloc]initWithService:snapshot.value[@"selectedService"] dateOfService:snapshot.value[@"dateOfService"] priceOfService:snapshot.value[@"costOfService"] userID:snapshot.value[@"userID"]];
//        if ([_currentUser.userServicesArray count] > 0) {
            for (NSString *key in snapshot.value){
                NSDictionary *individualServiceDictionary= [snapshot.value objectForKey:key];
                Service *dbServices = [[Service alloc]initWithService:individualServiceDictionary[@"selectedService"] dateOfService:[snapshot.value objectForKey:key][@"dateOfService"] priceOfService:[snapshot.value objectForKey:key][@"costOfService"] userID:[FIRAuth auth].currentUser.uid];
                [_currentUser.userServicesArray addObject: dbServices];
            }
//        } else {
//            NSLog(@"EMPTY Array");
//        }
        NSLog(@"Array holding services: %@", _currentUser.userServicesArray);
        
        [_upcomingServicesTableView reloadData];
        
    }];
    
}

// Style ***************************************************************************************************
//- (void)drawerMethod{
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }
//}

- (void)setTableviewColor {
    _upcomingServicesTableView.backgroundColor = [UIColor colorWithRed:58.0/255.0 green:74.0/255.0 blue:96.0/255.0 alpha:1.0];
    
}

@end
