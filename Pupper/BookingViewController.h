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
#import "Service.h"
#import "User.h"

@interface BookingViewController : UIViewController<FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray *servicesOnSelectedDate;

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) Service *service;


@end
