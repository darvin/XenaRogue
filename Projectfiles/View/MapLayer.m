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
#define spriteSize 4

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


-(id) init {
    if (self=[super init]) {
        
        
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
- (void) removeMapNodeWithId:(GameObjectId) nodeId {
    
}

- (void) moveMapNodeWithId:(GameObjectId) nodeId toCoords:(Coords) coords {

}

- (void) addMapNodeWithId:(GameObjectId) nodeId withFrameName:(NSString*) frameName toCoords:(Coords) coords {
    if (![mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]]) {
        MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:frameName];
        sprite.position = ccp(coords.x*spriteSize, coords.y*spriteSize);
        
        [spriteSheet addChild:sprite];
        [mapNodesById setObject:sprite forKey:[NSValue valueWithGameObjectId:nodeId]];
    } else {
        //do nothing. object already is map sprite
    }
    
}



- (void) addMapNodeWithFrameName:(NSString*) frameName toCoords:(Coords) coords {
    MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:frameName];
    sprite.position = ccp(coords.x*spriteSize, coords.y*spriteSize);
        
    [spriteSheet addChild:sprite];    
}

@end
