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

@protocol ObjectWithCoords;
@protocol ConvertableToDictionary;

@class GameObject;
@class LocalPlayer;
typedef  enum  {
    GameMapLayerFloor = 0,
    GameMapLayerOnFloor,
    GameMapLayerStandingCreatures,
    GameMapLayerFlyingCreatures,
    GameMapLayerDEFAULT =999
    } GameMapLayer;

typedef Coords MapSize;
MapSize MapSizeMake(int x, int y);

typedef struct {
    Coords origin;
    MapSize size;
} MapRect;
MapRect MapRectMake(int x, int y, int width, int height);


@class Map;
@protocol MapDelegate <NSObject>
-(void) map:(Map*) map object:(GameObject*) object addedToCoords:(Coords)coords;
-(void) map:(Map*) map object:(GameObject*) object movedFromCoords:(Coords)fromCoords toCoords:(Coords) toCoords;
-(void) map:(Map*) map objectRemoved:(GameObject*)object;
@end

@interface Map : NSObject <ConvertableToDictionary> {
    NSMutableDictionary * objectsById;
    NSMutableDictionary * objectsByCoords;
}
@property (readonly) Coords size;
@property (weak) id<MapDelegate> delegate;
@property (readonly) MapRect rect;
- (id) initWithSize:(MapSize) size;
- (id) initAndGenerateWithLocalPlayer:(LocalPlayer*) localPlayer andSize:(MapSize) size;
- (BOOL) moveObject:(GameObject*)object toCoords:(Coords) coords;
- (void) putObject:(GameObject*)object toCoords:(Coords) coords;
- (void) removeObject:(GameObject*) object;
- (GameObject *) objectById:(GameObjectId) mapObjectId;
- (NSArray *) objectsAtCoords:(Coords) coords;
- (BOOL) isPassableAtCoords:(Coords) coords;
- (BOOL) isVisibleAtCoords:(Coords) coords;
- (BOOL) isShootableAtCoords:(Coords) coords;
@end
