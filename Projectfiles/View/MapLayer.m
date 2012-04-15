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



@implementation MapLayer
@synthesize delegate=_delegate;

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
         @"sheet.plist"];  
        spriteSheet = [CCSpriteBatchNode
                                          batchNodeWithFile:@"sheet.png"];
        
        
        [[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"animations.plist"];
        
        [spriteSheet.texture setAliasTexParameters];
        [self addChild:spriteSheet];
        
        mapNodesById = [[NSMutableDictionary alloc] init];
        self.isTouchEnabled = YES;

    }
    return self;
}

-(CGPoint) convertMapCoordsToNodePoint:(Coords) coords {
    return ccp(coords.x*spriteSize, size.y*spriteSize - coords.y*spriteSize);
}


- (Coords) convertNodePointToMapCoords:(CGPoint) point {
    return  CoordsMake(point.x/spriteSize, size.y- point.y/spriteSize);
}

- (void) removeMapNodeWithId:(GameObjectId) nodeId {
    
}

- (void) moveMapNodeWithId:(GameObjectId) nodeId toCoords:(Coords) coords {
    MapObjectSprite *sprite = [mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]];
    [sprite runAction: [CCMoveTo actionWithDuration:1 position:[self convertMapCoordsToNodePoint:coords]]];
}

- (void) moveMapNodeWithId:(GameObjectId) nodeId toCoords:(Coords) coords withAnimation:(NSString*) animationName andFrameNameFinal:(NSString*) frameNameFinal {
    MapObjectSprite *sprite = [mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]];

    NSLog(@"%@", animationName);
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
    CCAction *animateAction = nil;
    if ( animation != nil ) {
        animateAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
        [sprite runAction:animateAction];
    }
    
    
    CCAction *moveAction = [CCSequence actions:                          
                       [CCMoveTo actionWithDuration:1 position:[self convertMapCoordsToNodePoint:coords]],
                       [CCCallBlock actionWithBlock:^{
        [sprite stopAction:animateAction];
        [self setFrameName:frameNameFinal toMapNodeWithId:nodeId];
        
    }],
                       nil];
    [sprite runAction:moveAction];

}
- (void) setFrameName:(NSString*) frameName toMapNodeWithId:(GameObjectId) nodeId {
    MapObjectSprite *sprite = [mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]];
    [sprite setTextureRect:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameName ].rect ];

}
- (void) addMapNodeWithId:(GameObjectId) nodeId withFrameName:(NSString*) frameName toCoords:(Coords) coords {
    if (![mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]]) {
        MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:[frameName stringByAppendingString:@".png"]];
        sprite.position = [self convertMapCoordsToNodePoint:coords];
        
        [spriteSheet addChild:sprite z:1000];
        [mapNodesById setObject:sprite forKey:[NSValue valueWithGameObjectId:nodeId]];
    } else {
        //do nothing. object already is map sprite
    }
    
}


- (void) addMapTile:(LandscapeMapTile) mapTile withNeighbours:(LandscapeMapTile[8]) neighbours toCoords:(Coords) coords {
    NSString *frameName = [[LandscapeAssetChooser sharedChooser] frameNameForMapTile:mapTile withNeighbours:neighbours];
    MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:frameName];
    sprite.position = [self convertMapCoordsToNodePoint:coords];
    NSLog(@"%@,  %d,%d    %d",frameName, coords.x, coords.y, mapTile);
    [spriteSheet addChild:sprite]; 
}

- (CGRect) boundingBox {
    return CGRectMake(0, 0, size.x*spriteSize, size.y*spriteSize);
}



- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];

    CGPoint location = [self convertTouchToNodeSpace:touch];
    [self.delegate mapLayer:self touchedAtCoords:[self convertNodePointToMapCoords:location]];
}

@end
