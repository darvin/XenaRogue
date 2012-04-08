//
//  GameLayer.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameLayer.h"
#import "CCScrollLayer.h"
#import "MapLayer.h"
@implementation GameLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



-(id) init {
    if (self=[super init]) {
        CCScrollLayer *scrollLayer = [CCScrollLayer scrollLayerWithViewSize:[[CCDirector sharedDirector] winSize]];
        MapLayer * mapLayer = [[MapLayer alloc] init];
        scrollLayer.contentSize = CGSizeMake(100*8, 100*8);
        
        // Add whatever you want to the scroll layer using addChild:
        
        // Add the layer to the scene.
        [self addChild:scrollLayer];
        [scrollLayer addChild:mapLayer];

    }
    return self;
}


@end
