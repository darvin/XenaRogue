//
//  Creature.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Creature.h"
#import "Item.h"
#import "GameModel.h"
#import "GameModelNotifications.h"
@implementation Creature
@synthesize direction=_direction, hp=_hp;
-(id) init {
    if (self=[super init]) {
        _direction = MapDirectionS;
        rallyPoint = CoordsNull;
        _hp = RANDOM(1, 10);
    }
    return self;
}

- (GameMapLayer) mapLayer {
    return GameMapLayerStandingCreatures;
}

- (BOOL) moveToCoords:(Coords) coords{ 
    self.direction = MapDirectionFromDeltaCoords(self.coords, coords);
    BOOL result;
    
    if ([self.map isPassableAtCoords:coords]) {
        result = [super moveToCoords:coords];
    } else {
        result = NO;
    }
    for (GameObject*objectToBump in [self.map objectsAtCoords:coords]) {
        if (objectToBump!=self) {
            [objectToBump interactedWithObject:self];
        }
    }
    return result;
}

- (void) directiveMove:(Coords) coords {
    if (LandscapeMapTileIsPassable(([self.map landscapeMapTileAtCoords:coords]))) {
        rallyPoint = coords;
        //    [self moveToCoords:coords];
        NSLog(@"%d %d", coords.x, coords.y);

    }
}

-(BOOL) isRemovable {
    return YES;
}
-(BOOL) isPassable {
    return NO;
}

-(void) tick {
    if (!CoordsIsNull(rallyPoint)) {
        if (abs(self.coords.x-rallyPoint.x)<=1&&abs(self.coords.y-rallyPoint.y)<=1) {
            [self moveToCoords:rallyPoint];
            rallyPoint = CoordsNull;
        } else {
            NSArray * path = [[self map] findPathFromCoords:self.coords toCoords:rallyPoint allowDiagonal:NO];
            NSValue *firstStep = [path lastObject];
            NSLog(@"step: %d,%d",[firstStep coordsValue].x,[firstStep coordsValue].y);
            [self moveToCoords:[firstStep coordsValue]];

        }
        
    }
}

-(NSDictionary*) toDictionary {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:[super toDictionary]];
    [result setValue:[NSValue valueWithMapDirection:_direction] forKey:@"direction"];
    return [NSDictionary dictionaryWithDictionary:result];
}

-(NSString*) assetName {
    return @"blueSkeleton";
}


-(void) interactedWithObject:(GameObject *)object {
    self.hp -= 1;
    [self notifyCreatureLostHP];
    [GameModel log:[NSString stringWithFormat: @"%@ attacked %@ on 1hp", object, self]];
}

- (void) notifyCreatureLostHP {
    [[NSNotificationCenter defaultCenter] postNotificationName:GMNGameCreatureLostHP object:self];
}


-(void) die {
    Item* corpse = [Item itemWithTypeName:@"corpse"];

    [self.map putObject:corpse toCoords:self.coords];

    [self removeFromMap];
}

-(void) setHp:(int)hp {
    _hp = hp;
    if (_hp<=0) {
        [self die];
    }
}
-(void) pickupItem:(Item*)item {
    //fixme implement
}

-(NSString*) description {
    return @"Creature";
}


-(uint) fovDistance {
    return 5;
}
@end
