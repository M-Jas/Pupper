//
//  SidebarViewController.m
//  Pupper
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "ProfileViewController.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation SidebarViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _menuItems = @[@"profile", @"payment", @"price", @"home", @"logout"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController *)segue.destinationViewController;
    
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row]capitalizedString];
    
    if([segue.identifier isEqualToString:@"profileSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        ProfileViewController *profileController = [navController childViewControllers].firstObject;
        
    }
    
}





@end
