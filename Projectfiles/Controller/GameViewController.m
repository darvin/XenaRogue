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
        self.map = [[Map alloc] initAndGenerateWithLocalPlayer:localPlayer andSize:MapSizeMake(100, 100)];
        self.mapLayer = [[MapLayer alloc] init];
        [self drawMapRect:self.map.rect];
    }
    return self;
}



- (void) drawMapRect:(MapRect) mapRect {
    
    for (int x = mapRect.origin.x; x<mapRect.origin.x+mapRect.size.x; x++) {
        for (int y = mapRect.origin.y; x<mapRect.origin.y+mapRect.size.y; y++) {
            for (GameObject* object in [self.map objectsAtCoords:CoordsMake(x, y)]) {
                
                [self.mapLayer addMapNodeWithId:object.objectId withFrameName:[object frameName] toCoords:CoordsMake(x, y)];
                
                
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
