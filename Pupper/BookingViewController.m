//
//  BookingViewController.m
//  Pupper
//
//  Created by DetroitLabs on 7/13/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//


#import "BookingViewController.h"
#import "SWRevealViewController.h"
#import "Service.h"
#import "User.h"



@interface BookingViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *upcomingServicesTableView;

@property (strong , nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSString *dateString;

@end

//NSDictionary *selectedServiceDict;


@implementation BookingViewController



- (void)viewDidLoad {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    _servicesOnSelectedDate = [[NSMutableArray alloc]init];
    [self createUser];
    [super viewDidLoad];
    
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
                                                              
//                                                            [_servicesOnSelectedDate addObject:@"Walk"];
                                                              _service = [[Service alloc]initWithService:@"Walk" dateOfService:_dateString priceOfService:[NSNumber numberWithDouble:10.00]];
                                                             
//                                                              [_servicesOnSelectedDate addObject:_service];
                                                              [_user.userServicesArray addObject:_service];
                                                              NSLog(@"the user array : %@", _user.userServicesArray);
                                                              for (Service *s in _user.userServicesArray){
                                                                  NSLog(@"&&&&&& %@", s.dateOfService);
                                                              }
                                                                  [_upcomingServicesTableView reloadData];
                                                          }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Feeding"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           
                                                               _service = [[Service alloc]initWithService:@"Feeding" dateOfService:_dateString priceOfService:[NSNumber numberWithDouble:5.00]];
                                                             
                                                           }];

    [alert addAction:firstAction];
    [alert addAction:secondAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_user.userServicesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath:indexPath];

    
    Service *testObject = [_user.userServicesArray objectAtIndex: indexPath.row];
    NSString *testDate = testObject.dateOfService;
    
     NSLog(@"FROM TABLEVIEW service type:%@ date:%@ cost:%@", _service.selectedService, _service.dateOfService, _service.priceOfService);
    cell.textLabel.text = testDate;
    
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
        [_user.userServicesArray removeObjectAtIndex: indexPath.row];
        [_upcomingServicesTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
}


- (void)createUser{
    _user = [[User alloc]init];
    _user.userServicesArray = [[NSMutableArray alloc]init];
}

@end
