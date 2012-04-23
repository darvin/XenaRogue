//
//  GameModel.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/12/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalPlayer.h"
#import "Map.h"
#import "Tickable.h"
#define mapSizeX 30
#define mapSizeY 30

@interface GameModel : NSObject <Tickable>
@property (strong) Map* currentMap;
@property (strong) LocalPlayer* localPlayer;

-(id) initWithNewLocalPlayer;
-(id) initWithSavedLocalPlayer;
-(void) playerChangedMap:(Player*) player;
@end
