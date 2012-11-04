//
//  GameLayer.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "CCLayerPanZoom.h"

#define timeInTick 1
#define MAP_MAX_SCALE 5
#define MAP_MIN_SCALE 0.1
@class SneakyJoystick;
@class GameViewController;

@interface GameLayer : CCLayer <CCLayerPanZoomClickDelegate> {
    float deltaSinceTick;
    GameViewController *vc;
}
@property(weak) SneakyJoystick *joystick;
@end
