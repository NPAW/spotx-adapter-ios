//
//  Utils.m
//  iOSObjc
//
//  Created by nice on 18/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

#import "Utils.h"
#import "Constants.h"

@implementation Utils

+(MenuSegue)translateToSegue:(NSString*)segueIdentifier {
    if ([segueIdentifier isEqualToString:BASIC_SEGUE_IDENTIFIER]) {
        return BASIC;
    }
    
    return UNKNOWN;
}

+(NSString*)translateSegueIdentifier:(MenuSegue)segue {
    switch (segue) {
        case BASIC:
            return BASIC_SEGUE_IDENTIFIER;
        default:
            return UNKNOWN_SEGUE_IDENTIFIER;
    }
}

@end
