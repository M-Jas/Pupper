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

@property (weak , nonatomic) FSCalendar *calendar;
@end

@implementation BookingViewController 
//    NSDate *dateSelected;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    FSCalendar *calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
//    
//    calendar.dataSource = self;
//    calendar.delegate = self;
//    [self.view addSubview:calendar];
//    self.calendar = calendar;
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_servicesOnSelectedDate count];
}


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


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    
    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    NSLog(@"selected date: %@", date);
//    [self filterEventsByDate:date];
}


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




@end
