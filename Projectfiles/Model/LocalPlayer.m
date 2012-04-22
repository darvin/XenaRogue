//
//  LocalPlayer.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "LocalPlayer.h"

@implementation LocalPlayer
- (id) initWithXp:(NSUInteger) xpNumber {
    if (self = [super init]) {
        self.xp = xpNumber;
    }
    return self;
}
-(NSString*) assetName {
    return @"localPlayer";
}
@end
