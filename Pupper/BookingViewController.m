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

Firebase *firebase;

@implementation BookingViewController


- (void)viewDidLoad {
    
//    if (user != nil) {
//        [_currentUser.userServicesArray addObject:(_service ==  )
//    } else {
//        // No user is signed in.
//    }
    
    [super viewDidLoad];
    [self retriveServicesFromFBDB];
    
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Service Options"
                                                                   message:@"Please select a service for Puppy"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
   UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Walk"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

                                                              _service = [[Service alloc]initWithService:@"Walk" dateOfService:_dateString priceOfService:[NSNumber numberWithDouble:10.00] userID:[FIRAuth auth].currentUser.uid];

                                                              //Add service obj to users array for services
                                                              [_currentUser.userServicesArray addObject:_service];
                                                              NSLog(@"Walking array: %@", _currentUser.userServicesArray);
                                                              //Add service obj to FireBase
                                                              [self addServiceToDB:_service];
                                                              //Reload table after click
                                                              [_upcomingServicesTableView reloadData];
                                                          }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Feeding"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           
                                                               _service = [[Service alloc]initWithService:@"Feeding" dateOfService:_dateString priceOfService:[NSNumber numberWithDouble:5.00] userID:[FIRAuth auth].currentUser.uid];
                                                               //Add service obj to users array for services
                                                               [_currentUser.userServicesArray addObject:_service];
                                                               //Add service obj to FireBase
                                                               [self addServiceToDB:_service];
                                                               //Reload table after click
                                                               [_upcomingServicesTableView reloadData];
                                                           }];

    [alert addAction:firstAction];
    [alert addAction:secondAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_currentUser.userServicesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath:indexPath];
    Service *newService = [_currentUser.userServicesArray objectAtIndex: indexPath.row];
    NSString *newDate = newService.dateOfService;
    NSString *newSelectedService = newService.selectedService;
    
    cell.textLabel.text = newDate;
    cell.detailTextLabel.text = newSelectedService;
//    NSLog(@"details: %@", cell.detailTextLabel.text);
    
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
        [_currentUser.userServicesArray removeObjectAtIndex: indexPath.row];
        [_upcomingServicesTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
}


- (void)addServiceToDB:(Service *)service {
    //Create reference to the firebase database
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    //Use the reference from above to add a child to that db as a "group"
    FIRDatabaseReference *serviceRef = [[firebaseRef child:@"services"] childByAutoId];
    
    //The dict is going to be the way to structure the database
    //Need to add in the user id once that is created to tie relationship
    NSDictionary *serviceDict = @{
                                  @"selectedService": service.selectedService,
                                  @"dateOfService": service.dateOfService,
                                  @"costOfService": service.priceOfService,
                                  @"userID": service.currentUserID
                                  };
    
    [serviceRef setValue:serviceDict];
}

- (void)retriveServicesFromFBDB {
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    // Use the reference from above to get the child from the db as a "group"
    FIRDatabaseReference *serviceRef = [firebaseRef child:@"services"];
    
    // FIRDataEventTypeChildAdded event is triggered once for each existing child and then again every time a new child is added to the specified path.
    [serviceRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
        NSLog(@"value coming from my db: %@", snapshot.value);
      
        Service *dbServices = [[Service alloc]initWithService:snapshot.value[@"selectedService"] dateOfService:snapshot.value[@"dateOfService"] priceOfService:snapshot.value[@"costOfService"] userID:snapshot.value[@"userID"]];
        
        
        //[_currentUser.userServicesArray addObject:snapshot.value];
        
        [_currentUser.userServicesArray addObject:dbServices];
        NSLog(@" servicearray: %@", _currentUser.userServicesArray);
        
        for(Service *s in _currentUser.userServicesArray) {
            NSLog(@" service from DB %@", s.dateOfService);
        }
        
        [_upcomingServicesTableView reloadData];
    }];
    
}


@end
