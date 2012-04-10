//
//  MapController.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameViewController.h"
#import "Map.h"
#import "GameObject.h"
@implementation GameViewController 
@synthesize map=_map, mapLayer=_mapLayer, localPlayer=_localPlayer;


-(id) initWithLocalPlayer:(LocalPlayer*) localPlayer {
    if (self=[super init]) {
        _localPlayer=localPlayer;
        self.map = [[Map alloc] initAndWithLocalPlayer:localPlayer andURL:[[NSBundle mainBundle] URLForResource:@"map" withExtension:@"txt"]];
        self.mapLayer = [[MapLayer alloc] initWithSize:self.map.size];
        [self drawMapRect:self.map.rect];
    }
    return self;
}



- (void) drawMapRect:(MapRect) mapRect {
    
    for (int x = mapRect.origin.x; x<mapRect.origin.x+mapRect.size.x; x++) {
        for (int y = mapRect.origin.y; y<mapRect.origin.y+mapRect.size.y; y++) {
            Coords coords = CoordsMake(x, y);
            LandscapeMapTile mapTile = [self.map landscapeMapTileAtCoords:coords];
            LandscapeMapTile neighbours [8];
            for (int direction=0; direction<MapDirection_MAX; direction++) {
                neighbours[direction] = [self.map landscapeMapTileOnDirection:direction fromCoords:coords];
            }
            [self.mapLayer addMapTile:mapTile withNeighbours:neighbours toCoords:coords];
            
            
            
            NSArray* objects = [self.map objectsAtCoords:coords];
            for (GameObject* object in objects) {
                
                [self.mapLayer addMapNodeWithId:object.objectId withFrameName:[object frameName] toCoords:coords];
            }
        }
    }
}

- (CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    

    // add layer as a child to scene
    [scene addChild: self.mapLayer];

    // return the scene
    return scene;
}

@end
