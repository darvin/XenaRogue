//
//  GameObject.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameObject.h"
static GameObjectId lastGameObjectId = 0;

@interface GameObject ()
- (BOOL) moveToCoords:(Coords) coords;
@end


@implementation GameObject

@synthesize coords = _coords, objectId=_objectId;

-(id) init {
    if (self=[super init]) {
        _objectId = ++lastGameObjectId;
    }
    return self;
}

- (GameMapLayer) mapLayer {
    return GameMapLayerDEFAULT;
}
- (BOOL) moveToCoords:(Coords) coords{
    return [self.map moveObject:self toCoords:coords];
}
@end
