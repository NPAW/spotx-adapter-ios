//
//  MenuViewController.m
//  iOSObjc
//
//  Created by nice on 30/10/2019.
//  Copyright © 2019 nice. All rights reserved.
//

#import "MenuViewController.h"
#import <YouboraConfigUtils/YouboraConfigUtils-Swift.h>
#import "PlayerViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController) {
        self.navigationController.delegate = self;
    }
}

- (IBAction)pressSettings:(id)sender {
    YouboraConfigViewController *settingsViewController = [[YouboraConfigViewController new] initFromXIB];
    [self.navigationController pushViewController:[settingsViewController initFromXIB] animated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PlayerViewController class]]) {
        ((PlayerViewController*)segue.destinationViewController).viewModel = [[PlayerViewModel alloc] initWithSegueIdentifier:segue.identifier];
    }
}

@end
