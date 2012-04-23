//
//  MonsterCreature.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/22/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "MonsterCreature.h"
#import "Player.h"
#define RANDOM_WALKING_RANGE 2
@implementation MonsterCreature
@synthesize enemy=_enemy;
-(void) tick {
    Player *enemyPlayer;
    
    if (beStupidNumberOfTicks) {
        beStupidNumberOfTicks--;
        
    } else if (self.enemy) {
        rallyPoint = self.enemy.coords;
    } else {
        self.enemy=[self.map playerInFOVOfCreature:self];
        if (!self.enemy&&(CoordsIsNull(rallyPoint)||CoordsIsEqual(rallyPoint, self.coords))) {
            rallyPoint = [self.map randomPassableCoordsInRect:MapRectMake(self.coords.x-RANDOM_WALKING_RANGE, self.coords.y-RANDOM_WALKING_RANGE, RANDOM_WALKING_RANGE*2, RANDOM_WALKING_RANGE*2)];
            beStupidNumberOfTicks = RANDOM(0, 4);
        }

    }
        
    [super tick];
}

-(void) interactedWithObject:(GameObject *)object {
    if ([object isKindOfClass:[Creature class]]) {
        self.enemy = (Creature*)object;
    }
    [super interactedWithObject:object];
}



-(NSString*) description {
    return @"Skeleton";
}
@end
