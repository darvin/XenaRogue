//
//  MapController.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameViewController.h"
#import "GameObject.h"
#import "GameModel.h"
#import "../Model/GameModelNotifications.h"

@implementation GameViewController
@synthesize map = _map, mapLayer = _mapLayer, localPlayer = _localPlayer, gameModel = _gameModel;


- (id)initWithGameModel:(GameModel *)gameModel
{
    if (self = [super init]) {
        self.gameModel = gameModel;
        self.mapLayer = [[MapLayer alloc] init];

        [self updateGameModel];
        [self subscribeToGameModelNotifications];


    }
    return self;
}

- (void)updateGameModel
{
    self.localPlayer = self.gameModel.localPlayer;
    self.map = self.gameModel.currentMap;
    [self.mapLayer cleanGameMap];
    self.mapLayer.mapSize = self.map.size;
    self.mapLayer.delegate = self;
    [self drawMapRect:self.map.rect];


}

- (void)dealloc
{ //fixme
    [self unsubscribeToGameModelNotifications];
}

- (void)subscribeToGameModelNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameObjectMoved:) name:GMNGameObjectMoved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameObjectChanged:) name:GMNGameObjectChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameObjectCreated:) name:GMNGameObjectCreated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameObjectRemoved:) name:GMNGameObjectRemoved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameCreatureLostHP:) name:GMNGameCreatureLostHP object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameMapChanged:) name:GMNGameMapChanged object:nil];

}

- (void)unsubscribeToGameModelNotifications
{
    //fixme: implement unsubsribtion
}

- (void)drawMapRect:(MapRect)mapRect
{
    //fixme: maprect+1
    for (int x = mapRect.origin.x; x <= mapRect.origin.x + mapRect.size.x; x++) {
        for (int y = mapRect.origin.y; y <= mapRect.origin.y + mapRect.size.y; y++) {
            Coords coords = CoordsMake(x, y);
            LandscapeMapTile mapTile = [self.map landscapeMapTileAtCoords:coords];
            LandscapeMapTile neighbours [8];
            for (int direction = 0; direction < MapDirection_MAX; direction++) {
                neighbours[direction] = [self.map landscapeMapTileOnDirection:direction fromCoords:coords];
            }
            [self.mapLayer addMapTile:mapTile withNeighbours:neighbours toCoords:coords];


            NSArray *objects = [self.map objectsAtCoords:coords];
            for (GameObject *object in objects) {
                object.coords = coords;
                [self updateGameObject:object];

            }
        }
    }
}

- (void)updateGameObject:(GameObject *)object
{
    [self.mapLayer addMapNodeWithId:object.objectId withFrameName:[self frameNameForGameObject:object action:@"stand"] toCoords:object.coords andGameMapLayer:object.mapLayer];
}

- (CCScene *)scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.


    // add layer as a child to scene
    [scene addChild:self.mapLayer];

    // return the scene
    return scene;
}

- (void)localPlayerJoystickPressedWithDirection:(MapDirection)direction
{
    Coords moveTo = CoordsSum(CoordsDeltaForDirection(direction), self.localPlayer.coords);

    [self.localPlayer directiveMove:moveTo];
}

- (NSString *)frameNameForGameObject:(GameObject *)gameObject action:(NSString *)action
{
    if (!action) {
        action = @"stand";
    }
    NSString *direction = @"";
    NSString *result;
    if ([gameObject isKindOfClass:[Creature class]]) {
        direction = [MapDirectionName nameMapDirection:((Creature *) gameObject).direction];
        direction = [direction substringToIndex:1];

        result = [NSString stringWithFormat:@"%@_%@_%@", gameObject.assetName, action, direction];

    } else {
        result = gameObject.assetName;
    }


    return result;

}

- (void)gameObjectMoved:(NSNotification *)notification
{
    GameObject *gameObject = notification.object;
    GameObjectId* objectId = gameObject.objectId;
    NSString *animation = [self frameNameForGameObject:gameObject action:@"walk"];
    NSString *finalFrame = [[self frameNameForGameObject:gameObject action:@"stand"] stringByAppendingString:@".png"];
    Coords newCoords = gameObject.coords;
    [self.mapLayer moveMapNodeWithId:objectId toCoords:newCoords withAnimation:animation andFrameNameFinal:finalFrame];
}

- (void)gameObjectChanged:(NSNotification *)notification
{
    GameObject *gameObject = notification.object;
    GameObjectId* objectId = gameObject.objectId;
    [self.mapLayer removeMapNodeWithId:objectId];
    [self updateGameObject:gameObject];
}

- (void)gameObjectRemoved:(NSNotification *)notification
{
    GameObject *gameObject = notification.object;
    GameObjectId* objectId = gameObject.objectId;
    [self.mapLayer removeMapNodeWithId:objectId];
}


- (void)gameObjectCreated:(NSNotification *)notification
{
    GameObject *gameObject = notification.object;
    [self updateGameObject:gameObject];
}

- (void)gameCreatureLostHP:(NSNotification *)notification
{
    Creature *creature = notification.object;
    [self.mapLayer showOverlayOnTileOnCoords:creature.coords withFrameName:@"animated_weapon" seconds:0.7];
}


- (void)gameMapChanged:(NSNotification *)notification
{
    [self updateGameModel];
}

- (void)mapLayer:(MapLayer *)mapLayer touchedAtCoords:(Coords)coords
{
//    DirectiveMove * dir = [[DirectiveMove alloc] initWithArgs:[NSArray arrayWithObjects:[NSValue valueWithGameObjectId*: self.localPlayer.objectId], [NSValue valueWithCoords:coords], nil]];
//    [dir runOnGameModel:self.gameModel];
    [self.localPlayer directiveMove:coords];
    [mapLayer showOverlayOnTileOnCoords:coords withFrameName:@"cursor" seconds:1];
}

@end
