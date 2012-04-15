//
//  LandscapeMapTile.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/9/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LandscapeMapTile_UNEXIST=-1,
    LandscapeMapTileEmpty=0,
    LandscapeMapTilePit,
    LandscapeMapTileCeiling,
    LandscapeMapTileFloor,
    LandscapeMapTileWall,
    LandscapeMapTileLava,
    LandscapeMapTileWater,
    LandscapeMapTileColumn,
    LandscapeMapTile_MAX,
} LandscapeMapTile;
BOOL LandscapeMapTileIsPassable(LandscapeMapTile mapTile);

#define kLandscapeMapTileNames @"empty", @"pit", @"ceiling", @"floor", @"wall", @"lava", @"water", @"column", nil
#define kLandscapeMapTileASCIIChars @"0", @" ", @"%", @".", @"#", @"-", @"w", @"|", nil
@interface LandscapeMapTileName : NSObject
+ (NSString*) nameForMapTile:(LandscapeMapTile) mapTile;
+ (LandscapeMapTile) mapTileForName:(NSString*) name;
+ (LandscapeMapTile) mapTileForASCIIChar:(NSString*) name;
@end
