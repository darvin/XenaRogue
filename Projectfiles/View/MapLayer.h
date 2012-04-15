//
//  MapLayer.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "CCLayer.h"
#import "Map.h"
#import "NSValue+GameObjectId.h"

#import "cocos2d.h"
#define spriteSize 16

@class MapLayer;

@protocol MapLayerDelegate <NSObject>

-(void) mapLayer:(MapLayer*) mapLayer touchedAtCoords:(Coords) coords;

@end

@interface MapLayer : CCLayer {
    NSMutableDictionary* mapNodesById;
    CCSpriteBatchNode *spriteSheet;
    MapSize size;
}
@property (weak) id<MapLayerDelegate> delegate;

- (id) initWithSize:(MapSize) mapSize;
- (void) removeMapNodeWithId:(GameObjectId) nodeId;
- (void) moveMapNodeWithId:(GameObjectId) nodeId toCoords:(Coords) coords;
- (void) moveMapNodeWithId:(GameObjectId) nodeId toCoords:(Coords) coords withAnimation:(NSString*) animationName andFrameNameFinal:(NSString*) frameNameFinal;
- (void) addMapNodeWithId:(GameObjectId) nodeId withFrameName:(NSString*) frameName toCoords:(Coords) coords;
- (void) addMapTile:(LandscapeMapTile) mapTile withNeighbours:(LandscapeMapTile[8]) neighbours toCoords:(Coords) coords;
@end
