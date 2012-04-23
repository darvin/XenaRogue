//
//  Map.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSValue+Coords.h"
#import "NSValue+GameObjectId.h"
#import "ConvertableToDictionary.h"
#import "LandscapeMapTile.h"
#import "Tickable.h"

#define kMapMAX_X 110
#define kMapMAX_Y 110
#define RANDOM(from, to) ((arc4random() % ((to)-(from)))+(from))


@protocol ObjectWithCoords;
@protocol ConvertableToDictionary;
@class GameModel;
@class GameObject;
@class LocalPlayer;
@class Player;
@class Creature;
typedef  enum  {
    GameMapLayerLandscape =0,
    GameMapLayerOnFloor,
    GameMapLayerStandingCreatures,
    GameMapLayerFlyingCreatures,
    GameMapLayerOverlay = 99,
    GameMapLayerDEFAULT =999
    } GameMapLayer;

typedef Coords MapSize;
MapSize MapSizeMake(int x, int y);

typedef struct {
    Coords origin;
    MapSize size;
} MapRect;
MapRect MapRectMake(int x, int y, int width, int height);


@interface Map : NSObject <ConvertableToDictionary, Tickable> {
    NSMutableDictionary * objectsById;
    NSMutableDictionary * objectsByCoords;
    LandscapeMapTile landscape[kMapMAX_X][kMapMAX_Y];
    
    struct 
    {
        BOOL walkable;
        
        BOOL onopen;
        BOOL onclosed;
        
        int g;
        int h;
        int f;
        
        Coords parent;
    } mapNodes[kMapMAX_X][kMapMAX_Y];
    
}
@property (readonly) Coords size;
@property (readonly) MapRect rect;
@property (weak) GameModel* gameModel;
- (id) initWithSize:(MapSize) size;
- (id) initAndGenerateWithLocalPlayer:(LocalPlayer*) localPlayer andSize:(MapSize) size;
- (id) initAndWithLocalPlayer:(LocalPlayer*) localPlayer andURL:(NSURL*)fileURL;
- (BOOL) moveObject:(GameObject*)object toCoords:(Coords) coords;
- (void) putObject:(GameObject*)object toCoords:(Coords) coords;
- (void) removeObject:(GameObject*) object;
- (GameObject *) objectById:(GameObjectId) mapObjectId;
- (NSArray *) objectsAtCoords:(Coords) coords;
- (BOOL) isPassableAtCoords:(Coords) coords;
- (BOOL) isVisibleAtCoords:(Coords) coords;
- (BOOL) isShootableAtCoords:(Coords) coords;
- (LandscapeMapTile) landscapeMapTileAtCoords:(Coords)coords;
- (LandscapeMapTile) landscapeMapTileOnDirection:(MapDirection)direction fromCoords:(Coords)coords;

- (NSArray*) findPathFromCoords:(Coords) start toCoords:(Coords) end allowDiagonal:(BOOL) allowDiagonal;

- (Coords) randomPassableCoordsInRect:(MapRect) rect ;

- (Player*) playerInFOVOfCreature:(Creature*)creature;
@end
