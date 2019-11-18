//
//  PlayerViewModel.h
//  iOSObjc
//
//  Created by nice on 18/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import "Utils.h"

@import SpotX;

NS_ASSUME_NONNULL_BEGIN

@interface PlayerViewModel : NSObject

@property MenuSegue selectedOption;

-(instancetype)initWithSegueIdentifier:(NSString*)segueIdentifier;

-(SpotXAdRequest*)getAdRequest;
-(NSURL*)getVideoUrl;

-(void)setAdsAdapter:(SpotXInterstitialAdPlayer*)player andDelegate:(id<SpotXAdPlayerDelegate>)delegate;
-(void)setAdapter:(AVPlayer*)player;

-(void)viewWillDisappear;
@end

NS_ASSUME_NONNULL_END
