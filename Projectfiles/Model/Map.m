//
//  Map.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Map.h"
#import "LocalPlayer.h"
#import "NSValue+Coords.h"
#import "Wall.h"
#define RANDOM(from, to) ((arc4random() % (to)-(from))+(from))


MapSize MapSizeMake(int x, int y) {
    MapSize result = {
        .x = x,
        .y = y
    };
    return result;
}

MapRect MapRectMake(int x, int y, int width, int height) {
    MapRect result = {
        .origin.x = x,
        .origin.y = y,
        .size.x = width,
        .size.y = height
    };
    return result;
}



@implementation Map
@synthesize size=_size;
- (id) initWithSize:(MapSize) size {
    if (self=[super init]) {
        objectsById = [[NSMutableDictionary alloc] init];
        objectsByCoords = [[NSMutableDictionary alloc] init];
        _size = size;
    }
    return self;
}

- (Coords) randomCoords {
//    return NULL;
}

- (MapRect) rect {
    return MapRectMake(0, 0, self.size.x, self.size.y);
}
- (void) putWallAtCoords:(Coords)coords{
//    NSLog(@"%d, %d", coords.x, coords.y);
    Wall * wall = [[Wall alloc] init];
    [self putObject:wall toCoords:coords];
}

- (void) generateDummyMap {
    Coords from = {
        .x = RANDOM(0, self.size.x/2),
        .y = RANDOM(0, self.size.y/2),
    };
    Coords til = {
        .x = RANDOM(self.size.x/2,self.size.x),
        .y = RANDOM(self.size.y/2,self.size.y),
    };
    for (int i=from.x; i<til.x; i++) {
        for (int j=from.y; j<til.y; j++) {
            [self putWallAtCoords:CoordsMake(i, from.y)];
            [self putWallAtCoords:CoordsMake(i, til.y)];
            [self putWallAtCoords:CoordsMake(from.x, j)];
            [self putWallAtCoords:CoordsMake(til.x, j)];
        }
    }
    
    
    
}

- (id) initAndGenerateWithLocalPlayer:(LocalPlayer*) localPlayer andSize:(MapSize) size {
    if (self=[self initWithSize:size]) {
        [self generateDummyMap];
    }
    return self;
}

- (NSMutableArray *) mutableObjectsAtCoords:(Coords) coords {
    return [objectsByCoords objectForKey:[NSValue valueWithCoords:coords]];
}

- (BOOL) moveObject:(GameObject*)object toCoords:(Coords) coords {
    [[self mutableObjectsAtCoords:object.coords] removeObject:object];
    [self putObject:object toCoords:coords];
    return YES;
}

- (void) putObject:(GameObject*)object toCoords:(Coords) coords{
    object.coords = coords;
    NSMutableArray * objects = [self mutableObjectsAtCoords:coords];
    if (!objects) {
        objects = [NSMutableArray arrayWithObject:object];
        [objectsByCoords setObject:objects forKey:[NSValue valueWithCoords:coords]];
    } else {
        [objects addObject:object];
    }
    [objectsById setObject:object forKey:[NSValue valueWithGameObjectId:object.objectId]];
}

- (void) removeObject:(GameObject*) object {
    [objectsById removeObjectForKey:[NSValue valueWithGameObjectId:object.objectId]];
    [[self mutableObjectsAtCoords:object.coords] removeObject:object];
    object.coords = CoordsNull;
}

- (GameObject *) objectById:(GameObjectId) mapObjectId {
    return [objectsById objectForKey:[NSValue valueWithGameObjectId:mapObjectId]];
}

- (NSArray *) objectsAtCoords:(Coords) coords {
    return [NSArray arrayWithArray:[self mutableObjectsAtCoords:coords]]; //sort by layer
}

- (BOOL) isPassableAtCoords:(Coords) coords {
    return YES;
}

- (BOOL) isVisibleAtCoords:(Coords) coords {
    return YES;
}

- (BOOL) isShootableAtCoords:(Coords) coords {
    return YES;
}


- (NSString *) frameNameForLayer:(GameMapLayer)layer AtCoords:(Coords) coords {
    NSMutableArray * objects = [self mutableObjectsAtCoords:coords];
    for (GameObject* object in objects) {
        if (layer==object.mapLayer) {
            return object.frameName;
        }
    }
    if (layer==GameMapLayerFloor) {
        return @"grey_floor";
    } else {
        return nil;
    }
    
}

@end
