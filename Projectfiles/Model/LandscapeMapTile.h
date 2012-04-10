//
//  LandscapeMapTile.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/9/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LandscapeMapTileEmpty=0,
    LandscapeMapTilePit,
    LandscapeMapTileCeiling,
    LandscapeMapTileFloor,
    LandscapeMapTileWall,
    LandscapeMapTileLava,
    LandscapeMapTile_MAX,
} LandscapeMapTile;
#define kLandscapeMapTileNames @"empty", @"pit", @"ceiling", @"floor", @"wall", @"lava", nil
@interface LandscapeMapTileName : NSObject
+ (NSString*) nameForMapTile:(LandscapeMapTile) mapTile;
+ (LandscapeMapTile) mapTileForName:(NSString*) name;
+ (LandscapeMapTile) mapTileForASCIIChar:(NSString*) name;
@end
