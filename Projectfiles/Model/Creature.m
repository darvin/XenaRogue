//
//  Creature.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Creature.h"

@implementation Creature
@synthesize direction=_direction;
-(id) init {
    if (self=[super init]) {
        _direction = MapDirectionS;
    }
    return self;
}

- (GameMapLayer) mapLayer {
    return GameMapLayerStandingCreatures;
}

- (BOOL) moveToCoords:(Coords) coords{ 
    self.direction = MapDirectionFromDeltaCoords(self.coords, coords);
    return [super moveToCoords:coords];
}

@end
