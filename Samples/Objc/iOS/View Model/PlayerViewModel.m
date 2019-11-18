//
//  PlayerViewModel.m
//  iOSObjc
//
//  Created by nice on 18/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

#import "PlayerViewModel.h"
#import <YouboraLib/YouboraLib.h>
#import <YouboraConfigUtils/YouboraConfigUtils-Swift.h>
#import <YouboraSpotXPlayerAdapter/YouboraSpotXPlayerAdapter-Swift.h>
#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>
#import "Constants.h"

@interface PlayerViewModel()

@property YBPlugin *plugin;

@end


@implementation PlayerViewModel

-(instancetype)initWithSegueIdentifier:(NSString*)segueIdentifier {
    self = [super init];
    
    if (self) {
        self.selectedOption = [Utils translateToSegue:segueIdentifier];
        
        YBOptions *options = [YouboraConfigManager getOptions];
        options.offline = NO;
        options.waitForMetadata = NO;
        
        options.adExpectedPattern = @{@"pre":[NSNumber numberWithInt:1]};
        
        self.plugin = [[YBPlugin alloc] initWithOptions:options];
    }
    
    return self;
}

-(void)setAdsAdapter:(SpotXInterstitialAdPlayer*)player andDelegate:(id<SpotXAdPlayerDelegate>)delegate {
    if (!player) { return; }
    
    YBPlayerAdapter *adapter = [[[YBSpotXPlayerAdAdapterManager alloc] initWithPlayer:player delegate:delegate] getAdapter];
    
    if(!player) { return; }
    
    self.plugin.adsAdapter = adapter;
}

-(void)setAdapter:(AVPlayer*)player {
    self.plugin.adapter = [[ YBAVPlayerAdapter alloc ] initWithPlayer:player];
}

-(SpotXAdRequest*)getAdRequest {
    SpotXAdRequest *request = [SpotXAdRequest new];
    [request setChannel:SPOT_X_TEST_CHANNEL];
    
    return request;
}

-(NSURL*)getVideoUrl {
    return [[NSURL alloc] initWithString:VIDEO_URL];
}

-(void)viewWillDisappear {
    [self.plugin removeAdsAdapter];
    [self.plugin removeAdapter];
}

@end
