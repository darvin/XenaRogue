//
//  MapController.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapDirection.h"
@class Map;
@class LocalPlayer;
@class GameModel;
@class MapLayer;
@interface GameViewController : NSObject
@property (weak) Map* map;
@property (strong) MapLayer* mapLayer;
@property (weak) LocalPlayer* localPlayer;
@property (strong) GameModel* gameModel;
-(id) initWithGameModel:(GameModel*) gameModel;
- (CCScene *) scene;
-(void) localPlayerJoystickPressedWithDirection:(MapDirection) direction;
@end
