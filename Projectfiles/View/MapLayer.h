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

#define spriteSize 32

@class MapLayer;

@protocol MapLayerDelegate <NSObject>

- (void)mapLayer:(MapLayer *)mapLayer touchedAtCoords:(Coords)coords;

@end

@interface MapLayer : CCLayer {
    NSMutableDictionary *mapNodesById;
    CCSpriteBatchNode *spriteSheet;
}
@property(weak) id <MapLayerDelegate> delegate;
@property MapSize mapSize;

- (void)removeMapNodeWithId:(GameObjectId)nodeId;

- (void)moveMapNodeWithId:(GameObjectId)nodeId toCoords:(Coords)coords;

- (void)moveMapNodeWithId:(GameObjectId)nodeId toCoords:(Coords)coords withAnimation:(NSString *)animationName andFrameNameFinal:(NSString *)frameNameFinal;

- (void)addMapNodeWithId:(GameObjectId)nodeId withFrameName:(NSString *)frameName toCoords:(Coords)coords andGameMapLayer:(GameMapLayer)gameMapLayer;

- (void)addMapTile:(LandscapeMapTile)mapTile withNeighbours:(LandscapeMapTile[8])neighbours toCoords:(Coords)coords;

- (void)clickedAtPoint:(CGPoint)location;

- (void)cleanGameMap;

- (void)showOverlayOnTileOnCoords:(Coords)coords withFrameName:(NSString *)frameName seconds:(float)seconds;
@end
