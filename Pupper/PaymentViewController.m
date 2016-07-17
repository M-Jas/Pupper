//
//  PaymentViewController.m
//  Pupper
//
//  Created by DetroitLabs on 7/13/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "PaymentViewController.h"
#import "SWRevealViewController.h"

@interface PaymentViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
