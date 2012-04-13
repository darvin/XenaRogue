//
//  GameLayer.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameLayer.h"

#import "GameViewController.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "ColoredCircleSprite.h"
#import "CCLayerPanZoom.h"
#import "GameModel.h"
@implementation GameLayer

@synthesize joystick=_joystick;


-(id) init {
    if (self=[super init]) {

        vc = [[GameViewController alloc] initWithGameModel:[[GameModel alloc] initWithNewLocalPlayer]];
        
        CCLayerPanZoom *panZoomLayer = [[CCLayerPanZoom alloc] init];
        
//        panZoomLayer.position = vc.mapLayer.boundingBoxCenter;
//        panZoomLayer.panBoundsRect = vc.mapLayer.boundingBox;
        [panZoomLayer addChild:vc.mapLayer];
        panZoomLayer.maxScale = 10;
        panZoomLayer.minScale = 2;
        panZoomLayer.mode = kCCLayerPanZoomModeSheet;
        [self addChild:panZoomLayer];
        SneakyJoystickSkinnedBase *leftJoy = [[SneakyJoystickSkinnedBase alloc] init];
		leftJoy.position = ccp(64,64);

		leftJoy.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:64];
		leftJoy.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 200) radius:32];
		leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
        leftJoy.joystick.isDPad = YES;
        leftJoy.joystick.numberOfDirections = 8;
        leftJoy.joystick.thumbRadius = 0.0f;
        self.joystick = leftJoy.joystick;
		[self addChild:leftJoy];
        
        //move to proper place
        [self schedule:@selector(tick:)];
        
    }
    return self;
}
-(void)tick:(float)dt {
    deltaSinceTick += dt;
    if (deltaSinceTick>=timeInTick) {
        deltaSinceTick = 0;
        if (self.joystick.degrees) {
            [vc localPlayerJoystickPressedWithDirection:MapDirectionFromDegrees(self.joystick.degrees)];

        }

    }
}

@end
