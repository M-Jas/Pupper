//
//  BookingViewController.h
//  Pupper
//
//  Created by DetroitLabs on 7/13/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JTCalendar/JTCalendar.h>
#import <FSCalendar/FSCalendar.h>

@interface BookingViewController : UIViewController<FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource>
//<JTCalendarDelegate>
//
//@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
//@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;
//@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;
//
//@property (strong, nonatomic) JTCalendarManager *calendarManager;
//
//@property (nonatomic, readonly) UIView *circleView;
@property (strong, nonatomic) NSMutableArray *servicesOnSelectedDate;





@end
