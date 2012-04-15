//
//  GameObject.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameObject.h"
#import "GameModelNotifications.h"
static GameObjectId lastGameObjectId = 0;

@interface GameObject ()
- (BOOL) moveToCoords:(Coords) coords;
@end


@implementation GameObject

@synthesize coords = _coords, objectId=_objectId, map=_map;

-(id) init {
    if (self=[super init]) {
        _coords = CoordsNull;
        _objectId = ++lastGameObjectId;
    }
    return self;
}

- (GameMapLayer) mapLayer {
    return GameMapLayerDEFAULT;
}
- (BOOL) moveToCoords:(Coords) coords{
    BOOL result = [self.map moveObject:self toCoords:coords];
    [[NSNotificationCenter defaultCenter] postNotificationName:GMNGameObjectMoved object:self];
    return result;
    
}

- (void) setCoords:(Coords)coords andMap:(Map*) map {
    _map = map;
    [self setCoords:coords];
}

- (void) setCoords:(Coords)coords {
    if (self.map) {
        _coords=coords;
    } else {
        @throw([NSException exceptionWithName:@"GameObjectException" reason:@"Setting of coords to object without map" userInfo:nil]);
    }
}
- (void) removeCoordsAndMap {
    if (self.map==nil||CoordsIsNull(self.coords)) {
        @throw([NSException exceptionWithName:@"GameObjectException" reason:@"Trying to remove object without map from map" userInfo:nil]);
    } else {
        _map = nil;
        _coords = CoordsNull;
    }
}

- (BOOL) isPassable {
    return YES;
}

-(void) tick {
    
}

-(NSDictionary*) toDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSValue valueWithGameObjectId:_objectId], @"objectId",
            [NSValue valueWithCoords:_coords], @"coords",
            NSStringFromClass([self class]), @"class", nil];
}

@end
