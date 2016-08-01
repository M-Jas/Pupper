//
//  PricingViewController.m
//  Pupper
//
//  Created by DetroitLabs on 7/13/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "PricingViewController.h"
#import "SWRevealViewController.h"

@interface PricingViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation PricingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawerMethod];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)drawerMethod{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

@end
