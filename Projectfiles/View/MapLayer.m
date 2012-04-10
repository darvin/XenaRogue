//
//  MapLayer.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//


#import "cocos2d.h"
#import "MapLayer.h"
#import "Map.h"
#import "NSValue+Coords.h"
#import "MapObjectSprite.h"
#import "LandscapeAssetChooser.h"


#define spriteSize 8

@implementation MapLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MapLayer *layer = [MapLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) initWithSize:(MapSize) mapSize {
    if (self=[super init]) {
        size = mapSize;
        [LandscapeAssetChooser sharedChooser];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"spritesheet_default.plist"];  
        spriteSheet = [CCSpriteBatchNode
                                          batchNodeWithFile:@"spritesheet_default.png"];
        [spriteSheet.texture setAliasTexParameters];
        [self addChild:spriteSheet];
        
        mapNodesById = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(CGPoint) coordsForMapCoords:(Coords) coords {
    return ccp(coords.x*spriteSize, size.y*spriteSize - coords.y*spriteSize);
}

- (void) removeMapNodeWithId:(GameObjectId) nodeId {
    
}

- (void) moveMapNodeWithId:(GameObjectId) nodeId toCoords:(Coords) coords {

}

- (void) addMapNodeWithId:(GameObjectId) nodeId withFrameName:(NSString*) frameName toCoords:(Coords) coords {
    if (![mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]]) {
        MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:frameName];
        sprite.position = [self coordsForMapCoords:coords];
        
        [spriteSheet addChild:sprite];
        [mapNodesById setObject:sprite forKey:[NSValue valueWithGameObjectId:nodeId]];
    } else {
        //do nothing. object already is map sprite
    }
    
}


- (void) addMapTile:(LandscapeMapTile) mapTile withNeighbours:(LandscapeMapTile[8]) neighbours toCoords:(Coords) coords {
    NSString *frameName = [[LandscapeAssetChooser sharedChooser] frameNameForMapTile:mapTile withNeighbours:neighbours];
    MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:frameName];
    sprite.position = [self coordsForMapCoords:coords];
    NSLog(@"%@,  %d,%d    %d",frameName, coords.x, coords.y, mapTile);
    [spriteSheet addChild:sprite]; 
}

- (CGRect) boundingBox {
    return CGRectMake(0, 0, size.x*spriteSize, size.y*spriteSize);
}

@end
