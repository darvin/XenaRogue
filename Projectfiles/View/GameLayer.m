//
//  GameLayer.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameLayer.h"

#import "GameViewController.h"
#import "GameModel.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "ColoredCircleSprite.h"
#import "CocosDebugLayer.h"

#endif

@implementation GameLayer

@synthesize joystick = _joystick;


- (id)init
{
    if (self = [super init]) {
        vc = [[GameViewController alloc] initWithGameModel:[[GameModel alloc] initWithNewLocalPlayer]];

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

        CocosDebugLayer *debugLayer = [CocosDebugLayer node];
        [self addChild:debugLayer z:10000];
        CGFloat consolePosition;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            consolePosition = 700;
        } else {
            consolePosition = 275;
        }

        debugLayer.position = CGPointMake(0, consolePosition);
        debugLayer.fixedY = consolePosition;


        CCLayerPanZoom *panZoomLayer = [[CCLayerPanZoom alloc] init];
        //        panZoomLayer.maxTouchDistanceToClick = 10;
        //        panZoomLayer.position = vc.mapLayer.boundingBoxCenter;
        //        panZoomLayer.panBoundsRect = vc.mapLayer.boundingBox;
        [panZoomLayer addChild:vc.mapLayer];
        vc.mapLayer.isTouchEnabled = NO;
        //        self.isTouchEnabled = YES;
        panZoomLayer.delegate = self;


        panZoomLayer.maxScale = MAP_MAX_SCALE;
        panZoomLayer.minScale = MAP_MIN_SCALE;
        panZoomLayer.mode = kCCLayerPanZoomModeSheet;
        [self addChild:panZoomLayer];
        SneakyJoystickSkinnedBase *leftJoy = [[SneakyJoystickSkinnedBase alloc] init];
        leftJoy.position = ccp(64, 64);

        leftJoy.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(205, 201, 201, 128) radius:64];
        leftJoy.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(238, 233, 233, 200) radius:32];
        leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
        leftJoy.joystick.isDPad = YES;
        leftJoy.joystick.numberOfDirections = 8;
        leftJoy.joystick.thumbRadius = 0.0f;
        self.joystick = leftJoy.joystick;
        [self addChild:leftJoy];
#else
        [self addChild:vc.mapLayer];
#endif


        //move to proper place
        [self schedule:@selector(tick:)];

    }
    return self;
}

- (void)tick:(float)dt
{
    deltaSinceTick += dt;
    if (deltaSinceTick >= timeInTick) {
        deltaSinceTick = 0;
        [vc.gameModel tick];

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        if (self.joystick.degrees) {
            [vc localPlayerJoystickPressedWithDirection:MapDirectionFromDegrees(self.joystick.degrees)];

        }
#endif

    }

}

- (void)layerPanZoom:(CCLayerPanZoom *)sender clickedAtPoint:(CGPoint)aPoint tapCount:(NSUInteger)tapCount
{
    [vc.mapLayer clickedAtPoint:aPoint];
}

@end
