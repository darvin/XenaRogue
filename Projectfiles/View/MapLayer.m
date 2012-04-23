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
@synthesize delegate=_delegate, mapSize=_mapSize;

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
        [LandscapeAssetChooser sharedChooser];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"sheet.plist"];  
        spriteSheet = [CCSpriteBatchNode
                                          batchNodeWithFile:@"sheet.png"];
        
        
        [[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"animations.plist"];
        
        [spriteSheet.texture setAliasTexParameters];
        [self addChild:spriteSheet];
        
        self.isTouchEnabled = YES;
        mapNodesById = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)cleanGameMap {
    [spriteSheet removeAllChildrenWithCleanup:YES];
    mapNodesById = [[NSMutableDictionary alloc] init];

}

-(CGPoint) convertMapCoordsToNodePoint:(Coords) coords {
    return ccp(coords.x*spriteSize, self.mapSize.y*spriteSize - coords.y*spriteSize);
}


- (Coords) convertNodePointToMapCoords:(CGPoint) point {
    return  CoordsMake((point.x-spriteSize/2)/spriteSize+1, self.mapSize.y- (point.y-spriteSize/2)/spriteSize);
}

- (void) removeMapNodeWithId:(GameObjectId) nodeId {
    MapObjectSprite * sprite = [mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]];
    [spriteSheet removeChild:sprite cleanup:YES];
    [mapNodesById removeObjectForKey:[NSValue valueWithGameObjectId:nodeId]];
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
//        [self setFrameName:frameNameFinal toMapNodeWithId:nodeId];
        
    }],
                       nil];
    [sprite runAction:moveAction];

}
- (void) setFrameName:(NSString*) frameName toMapNodeWithId:(GameObjectId) nodeId {
    NSLog(@"%@", frameName);
    MapObjectSprite *sprite = [mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]];
    [sprite setTextureRect:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameName ].rect ];

}
- (void) addMapNodeWithId:(GameObjectId) nodeId withFrameName:(NSString*) frameName toCoords:(Coords) coords andGameMapLayer:(GameMapLayer) gameMapLayer {
    if (![mapNodesById objectForKey:[NSValue valueWithGameObjectId:nodeId]]) {
        MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:[frameName stringByAppendingString:@".png"]];
        sprite.position = [self convertMapCoordsToNodePoint:coords];
        
        [spriteSheet addChild:sprite z:gameMapLayer];
        [mapNodesById setObject:sprite forKey:[NSValue valueWithGameObjectId:nodeId]];
    } else {
        //do nothing. object already is map sprite
    }
    
}


- (void) addMapTile:(LandscapeMapTile) mapTile withNeighbours:(LandscapeMapTile[8]) neighbours toCoords:(Coords) coords {
    NSString *frameName = [[LandscapeAssetChooser sharedChooser] frameNameForMapTile:mapTile withNeighbours:neighbours];
    MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:frameName];
    sprite.position = [self convertMapCoordsToNodePoint:coords];
//    NSLog(@"%@,  %d,%d    %d",frameName, coords.x, coords.y, mapTile);
    [spriteSheet addChild:sprite z:GameMapLayerLandscape]; 
}

- (CGRect) boundingBox {
    return CGRectMake(0, 0, self.mapSize.x*spriteSize, self.mapSize.y*spriteSize);
}



- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];

    [self clickedAtPoint: [self convertTouchToNodeSpace:touch]];
    
}


- (void) clickedAtPoint:(CGPoint) location {
    [self.delegate mapLayer:self touchedAtCoords:[self convertNodePointToMapCoords:location]];
}
-(void) showOverlayOnTileOnCoords:(Coords)coords withFrameName:(NSString*) frameName seconds:(float) seconds{
    MapObjectSprite *sprite = [[MapObjectSprite alloc] initWithSpriteFrameName:[frameName stringByAppendingString:@".png"]];
    sprite.position = [self convertMapCoordsToNodePoint:coords];
    //    NSLog(@"%@,  %d,%d    %d",frameName, coords.x, coords.y, mapTile);
    [spriteSheet addChild:sprite z:GameMapLayerOverlay]; 
    
    CCAction *disappearAction = [CCSequence actions:   
                                 [CCDelayTime actionWithDuration:seconds],
                            [CCFadeOut actionWithDuration:0.2],
                            [CCCallBlock actionWithBlock:^{
        [spriteSheet removeChild:sprite cleanup:YES];
        
    }],
                            nil];
    
    [sprite runAction:disappearAction];
}
@end
