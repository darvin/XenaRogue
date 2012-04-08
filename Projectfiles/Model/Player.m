//
//  Player.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize xp=_xp;
- (GameMapLayer) mapLayer {
    return GameMapLayerStandingCreatures;
}
-(NSString*) frameName {
    return @"fighter";
}
@end
