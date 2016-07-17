//
//  BookingViewController.m
//  Pupper
//
//  Created by DetroitLabs on 7/13/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//


#import "BookingViewController.h"
#import "SWRevealViewController.h"



@interface BookingViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITableView *upcomingServicesTableView;

@property (strong, nonatomic) NSDate *selectedDate;

@property (strong , nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSString *dateString;

@end

@implementation BookingViewController 

- (void)viewDidLoad {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [super viewDidLoad];
    
    _servicesOnSelectedDate = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_servicesOnSelectedDate count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath:indexPath];

    NSLog(@"%@", _dateString);
    
//    NSString *dateToDisplay = [_servicesOnSelectedDate objectAtIndex:indexPath.row];
//    NSLog(@"%@", dateToDisplay);
    
    NSString *testString = [_servicesOnSelectedDate objectAtIndex:indexPath.row];
    
//    cell.textLabel.text = _dateString;
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
        [_servicesOnSelectedDate removeObjectAtIndex: indexPath.row];
        [_upcomingServicesTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
}


// clicking on a date adds a string of "yyyy/MM/dd" into an array which is called to populate the tableview
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    _selectedDate = [[NSDate alloc]init];
    _selectedDate = date;
    
    _dateString =[calendar stringFromDate:date format:@"yyyy/MM/dd"];
    
    [_servicesOnSelectedDate addObject:_dateString];
    
    
    NSLog(@"%@", _dateString);
    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);

    //This is needed to populated the data after calendar date is selected
    [_upcomingServicesTableView reloadData];
    
}

@end

// calendar:prepareDayView: used to customize the design of the day view for a specific date. This method is called each time a new date is set in a dayView or each time the current page change.
//- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
//
//    dayView.hidden = NO;
//
//    if([dayView isFromAnotherMonth]) {
//        dayView.hidden = YES;
//    }
//    //Today
//    else if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [UIColor blueColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
//
//    }
//    //Selected Date
//    else if (dateSelected && [_calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date]) {
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [UIColor redColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
//    }
//    //Another Day
//    else {
//        dayView.circleView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor redColor];
//        dayView.textLabel.textColor = [UIColor blackColor];
//    }
// ask john on this
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }

//}
//
//- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView {
//    dateSelected = dayView.date;
//
//    //Animation for Circles
//    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
//    [UIView transitionWithView:dayView
//                      duration:.3
//                       options:0
//                    animations:^{
//                        dayView.circleView.transform = CGAffineTransformIdentity;
//                        [_calendarManager reload];
//                    } completion:nil];
//    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
//        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
//            [_calendarContentView loadNextPageWithAnimation];
//        } else {
//            [_calendarContentView loadPreviousPageWithAnimation];
//        }
//    }
//}




//- (NSDateFormatter *)dateFormatter
//{
//    static NSDateFormatter *dateFormatter;
//    if(!dateFormatter){
//        dateFormatter = [NSDateFormatter new];
//        dateFormatter.dateFormat = @"dd-MM-yyyy";
//    }
//    
//    return dateFormatter;
//}


//    _calendarManager = [JTCalendarManager new];
//    _calendarManager.delegate = self;
//
//    _calendarManager.settings.pageViewHaveWeekDaysView = NO; // You don't want WeekDaysView in the contentView
//    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic number of weeks
//
//    _weekDayView.manager = _calendarManager; // You set the manager for WeekDaysView
//    [_weekDayView reload]; // You load WeekDaysView manually
//
//    [_calendarManager setMenuView:_calendarMenuView];
//    [_calendarManager setContentView:_calendarContentView];
//    [_calendarManager setDate:[NSDate date]];
//
//    _calendarMenuView.scrollView.scrollEnabled = NO;


//
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }



