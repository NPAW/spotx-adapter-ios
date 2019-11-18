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

@property AVPlayerViewController *playerViewController;
@property SpotXInterstitialAdPlayer *adPlayer;
@property YBPlugin *plugin;

@property int playerItemContext;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAdsPlayer];
    [self initializePlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)initializeAdsPlayer {
    if (!self.viewModel) { return; }
    
    self.adPlayer = [SpotXInterstitialAdPlayer new];
    [self.viewModel setAdsAdapter:self.adPlayer andDelegate:self];
}

-(void)initializePlayer {
    if (!self.viewModel) { return; }
    
    // Video player controller
    self.playerViewController = [AVPlayerViewController new];
    
    // Add view to the current screen
    [self addChildViewController:self.playerViewController];
    [self.view addSubview:self.playerViewController.view];

    // We use the playerView view as a guide for the video
    self.playerViewController.view.frame = self.view.frame;
    
    NSURL *videoUrl = [self.viewModel getVideoUrl];
    
    if (!videoUrl) { return; }
    
    self.playerViewController.player = [[AVPlayer alloc] initWithURL:videoUrl];
    
    [self.viewModel setAdapter:self.playerViewController.player];
    
    [self observePlayer];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.viewModel) {return;}
    
    [self.viewModel viewWillDisappear];
}

//MARK: - AVPlayer observer methods

-(void)observePlayer {
    [self.playerViewController.player addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.playerViewController.player && [keyPath isEqualToString:@"status"]) {
        if (self.playerViewController.player.status == AVPlayerStatusReadyToPlay) {
            [self.adPlayer load];
            return;
        }
    }
}

//MARK: - SpotXAdPlayerDelegate methods

// Set customizable request parameters here, such as channel id
- (SpotXAdRequest *_Nullable)requestForPlayer:(SpotXAdPlayer *_Nonnull)player {
    if (!self.viewModel) {return nil;}
    
    return [self.viewModel getAdRequest];
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

- (void)spotx:(SpotXAdPlayer *)player adGroupStart:(SpotXAdGroup *)group {
    [self.playerViewController.player pause];
}

- (void)spotx:(SpotXAdPlayer *)player adGroupComplete:(SpotXAdGroup *)group {
    [self.playerViewController.player play];
}

//MARK: - Aux methods

-(void)showMessage:(NSString *)message {
  UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {}];
  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

@end
