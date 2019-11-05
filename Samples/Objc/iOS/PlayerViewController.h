//
//  PlayerViewController.h
//  iOSObjc
//
//  Created by nice on 30/10/2019.
//  Copyright © 2019 nice. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SpotX;

NS_ASSUME_NONNULL_BEGIN

@interface PlayerViewController : UIViewController <SpotXAdPlayerDelegate>

-(void) playInterstitial;

@end

NS_ASSUME_NONNULL_END
