//
//  LandscapeMapTile.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/9/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "LandscapeMapTile.h"


@implementation LandscapeMapTileName


+ (NSString*) nameForMapTile:(LandscapeMapTile) mapTile {
    return [[NSArray arrayWithObjects:kLandscapeMapTileNames] objectAtIndex:mapTile];
}
+ (LandscapeMapTile) mapTileForName:(NSString*) name {
    NSArray* names = [NSArray arrayWithObjects:kLandscapeMapTileNames];
    for (uint i=0; i<[names count];i++) {
        NSString* aname = [names objectAtIndex:i];
        if ([aname isEqualToString:name]){
            return i;
        }
    }
    return LandscapeMapTile_MAX;
}


+ (LandscapeMapTile) mapTileForASCIIChar:(NSString*) name {
    NSArray* names = [NSArray arrayWithObjects:@"0", @" ", @"%", @".", @"#", @"-", nil];
    for (uint i=0; i<[names count];i++) {
        NSString* aname = [names objectAtIndex:i];
        if ([aname isEqualToString:name]){
            return i;
        }
    }
    return LandscapeMapTile_MAX;
}

@end

