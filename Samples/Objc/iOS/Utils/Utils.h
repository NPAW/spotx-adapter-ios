//
//  Utils.h
//  iOSObjc
//
//  Created by nice on 18/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    BASIC,
    UNKNOWN
} MenuSegue;

@interface Utils : NSObject

+(MenuSegue)translateToSegue:(NSString*)segueIdentifier;
+(NSString*)translateSegueIdentifier:(MenuSegue)segue;


@end

NS_ASSUME_NONNULL_END
