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
#import "GameModel.h"
#import "MapLayer.h"
#import "DirectiveMove.h"
#import "MapDirection.h"
#import "../Model/GameModelNotifications.h"

@implementation GameViewController 
@synthesize map=_map, mapLayer=_mapLayer, localPlayer=_localPlayer, gameModel=_gameModel;


-(id) initWithGameModel:(GameModel*) gameModel {
    if (self=[super init]) {
        self.localPlayer = gameModel.localPlayer;
        self.map = gameModel.currentMap;
        self.gameModel = gameModel;
        self.mapLayer = [[MapLayer alloc] initWithSize:self.map.size];
        self.mapLayer.delegate = self;
        [self drawMapRect:self.map.rect];
        
        [self subscribeToGameModelNotifications];
    }
    return self;
}

- (void) dealloc { //fixme
    [self unsubscribeToGameModelNotifications];
}

- (void) subscribeToGameModelNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameObjectMoved:) name:GMNGameObjectMoved object:nil];
}

- (void) unsubscribeToGameModelNotifications {

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
                
                [self.mapLayer addMapNodeWithId:object.objectId withFrameName:[self frameNameForGameObject:object action:@"stand"] toCoords:coords];
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

-(void) localPlayerJoystickPressedWithDirection:(MapDirection) direction {
    Coords moveTo = CoordsSum(CoordsDeltaForDirection(direction), self.localPlayer.coords);
    
    DirectiveMove * dir = [[DirectiveMove alloc] initWithArgs:[NSArray arrayWithObjects:[NSValue valueWithGameObjectId: self.localPlayer.objectId], [NSValue valueWithCoords:moveTo], nil]];
    [dir runOnGameModel:self.gameModel];
}

-(NSString *) frameNameForGameObject:(GameObject*) gameObject action:(NSString*) action {
    if (!action) {
        action = @"stand";
    }
    NSString *direction = @"";
    if ([gameObject isKindOfClass:[Creature class]]) {
        direction = [MapDirectionName nameMapDirection:((Creature*)gameObject).direction] ;
        direction = [direction substringToIndex:1];
        
    }
     
    
    NSString* result = [NSString stringWithFormat:@"%@_%@_%@", gameObject.frameName, action, direction];
    return result;
    
}

-(void) gameObjectMoved:(NSNotification*) notification {
    GameObject* gameObject = notification.object;
    GameObjectId objectId = gameObject.objectId;
    [self.mapLayer moveMapNodeWithId:objectId toCoords:gameObject.coords withAnimation:[self frameNameForGameObject:gameObject action:@"walk"] andFrameNameFinal:[[self frameNameForGameObject:gameObject action:@"stand"] stringByAppendingString:@".png"]];
}

- (void) mapLayer:(MapLayer *)mapLayer touchedAtCoords:(Coords)coords {
    DirectiveMove * dir = [[DirectiveMove alloc] initWithArgs:[NSArray arrayWithObjects:[NSValue valueWithGameObjectId: self.localPlayer.objectId], [NSValue valueWithCoords:coords], nil]];
    [dir runOnGameModel:self.gameModel];
}

@end
