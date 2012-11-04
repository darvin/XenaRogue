//
//  LandscapeMapTile.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/9/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "LandscapeMapTile.h"

BOOL LandscapeMapTileIsPassable(LandscapeMapTile mapTile) {
    return mapTile == LandscapeMapTileFloor;
}

@implementation LandscapeMapTileName


+ (NSString *)nameForMapTile:(LandscapeMapTile)mapTile
{

    if (mapTile > [[NSArray arrayWithObjects:kLandscapeMapTileNames] count]) {
        @throw [NSException exceptionWithName:@"" reason:@"" userInfo:@{
        }];
    }
    return [NSArray arrayWithObjects:kLandscapeMapTileNames][mapTile];
}

+ (LandscapeMapTile)mapTileForName:(NSString *)name
{
    NSArray *names = [NSArray arrayWithObjects:kLandscapeMapTileNames];
    for (uint i = 0; i < [names count]; i++) {
        NSString *aname = names[i];
        if ([aname isEqualToString:name]) {
            return i;
        }
    }
    @throw [NSException exceptionWithName:@"MapTileError" reason:@"invalid name" userInfo:nil];
    return LandscapeMapTile_UNEXIST;
}


+ (LandscapeMapTile)mapTileForASCIIChar:(NSString *)name
{
    NSArray *names = [NSArray arrayWithObjects:kLandscapeMapTileASCIIChars];
    for (uint i = 0; i < [names count]; i++) {
        NSString *aname = names[i];
        if ([aname isEqualToString:name]) {
            return i;
        }
    }

    @throw [NSException exceptionWithName:@"MapTileError" reason:[NSString stringWithFormat:@"invalid char %@", name] userInfo:@{@"char": name}];
    return LandscapeMapTile_UNEXIST;
}

@end

