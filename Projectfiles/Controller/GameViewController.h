//
//  MapController.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "MapLayer.h"
@interface GameViewController : NSObject
@property (strong) Map* map;
@property (strong) MapLayer* mapLayer;
@property (strong) LocalPlayer* localPlayer;
-(id) initWithLocalPlayer:(LocalPlayer*) localPlayer;
- (CCScene *) scene;
@end
