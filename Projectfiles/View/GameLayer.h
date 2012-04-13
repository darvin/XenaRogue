//
//  GameLayer.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#define timeInTick 0.4
@class SneakyJoystick;
@class GameViewController;
@interface GameLayer : CCLayer {
    float deltaSinceTick;
    GameViewController * vc;
}
@property (weak) SneakyJoystick* joystick;
@end
