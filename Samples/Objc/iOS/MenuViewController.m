//
//  MenuViewController.m
//  iOSObjc
//
//  Created by nice on 30/10/2019.
//  Copyright © 2019 nice. All rights reserved.
//

#import "MenuViewController.h"
#import <YouboraConfigUtils-Swift.h>
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
    YouboraConfigViewController *settingsViewController = [[YouboraConfigViewController alloc] init];
    [self.navigationController pushViewController:[settingsViewController initFromXIB] animated:true];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[PlayerViewController class]]) {
        [((PlayerViewController*) viewController) playInterstitial];
    }
}
@end
