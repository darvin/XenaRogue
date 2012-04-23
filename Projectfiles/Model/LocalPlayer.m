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
        self.hp = 10000;
    }
    return self;
}
-(NSString*) assetName {
    return @"localPlayer";
}
-(void) interactedWithObject:(GameObject *)object {
//fixme implement
}
@end
