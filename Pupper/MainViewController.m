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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainDisplayUpcomingServices;


@end

@implementation MainViewController

NSMutableArray *upcomingServicesArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testingTVMethod];
    
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
