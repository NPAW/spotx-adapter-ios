//
//  PlayerViewController.m
//  iOSObjc
//
//  Created by nice on 30/10/2019.
//  Copyright © 2019 nice. All rights reserved.
//

#import "PlayerViewController.h"
#import "Constants.h"
#import <YouboraSpotXPlayerAdapter/YouboraSpotXPlayerAdapter-Swift.h>
#import <YouboraLib/YouboraLib.h>
#import <YouboraConfigUtils/YouboraConfigUtils-Swift.h>

@import SpotX;

@interface PlayerViewController ()

@property SpotXInterstitialAdPlayer *player;
@property YBPlugin *plugin;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [[SpotXInterstitialAdPlayer alloc] init];
    self.player.delegate = self;
    
    [self setPlugin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) playInterstitial {
  [self.player load];
}

//MARK: - SpotXAdPlayerDelegate methods

// Set customizable request parameters here, such as channel id
- (SpotXAdRequest *_Nullable)requestForPlayer:(SpotXAdPlayer *_Nonnull)player {
  SpotXAdRequest * request = [[SpotXAdRequest alloc] init];
    
  // This SpotX channel id can be used for testing
  [request setChannel: SPOT_X_TEST_CHANNEL];

  return request;
}

// Play the ad(s) if they were returned
- (void)spotx:(SpotXAdPlayer *_Nonnull)player didLoadAds:(SpotXAdGroup *_Nullable)group error:(NSError *_Nullable)error {
  if (group.ads.count > 0) {
    [player start];
  }
  else {
    [self showMessage:@"No Ads Available"];
  }
}

//MARK: - Aux methods

-(void)setPlugin {
    YBSpotXPlayerAdAdapterManager *adapterManger = [[YBSpotXPlayerAdAdapterManager alloc] initWithPlayer:self.player];
    YBOptions *options = [YouboraConfigManager getOptions];
    
    self.plugin = [[YBPlugin alloc] initWithOptions:options andAdapter:[adapterManger getAdapter]];
}

-(void)showMessage:(NSString *)message {
  UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {}];
  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

@end
