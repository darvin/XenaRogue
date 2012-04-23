//
//  MonsterCreature.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/22/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "MonsterCreature.h"
#define RANDOM_WALKING_RANGE 2
@implementation MonsterCreature
-(void) tick {
    if (CoordsIsNull(rallyPoint)||CoordsIsEqual(rallyPoint, self.coords)) {
        rallyPoint = [self.map randomPassableCoordsInRect:MapRectMake(self.coords.x-RANDOM_WALKING_RANGE, self.coords.y-RANDOM_WALKING_RANGE, RANDOM_WALKING_RANGE*2, RANDOM_WALKING_RANGE*2)];
    }
    [super tick];
}
@end
