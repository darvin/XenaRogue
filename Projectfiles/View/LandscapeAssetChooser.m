//
//  LandscapeAssetChooser.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/9/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "LandscapeAssetChooser.h"

@implementation LandscapeAssetChooserRule
@synthesize tileIndex = _tileIndex;

- (id)initWithTileIndex:(NSUInteger)tileIndex
{
    if (self = [super init]) {
        for (int i = 0; i < 8; i++) {
            equals[i] = LandscapeMapTile_MAX;
            notEquals[i] = LandscapeMapTile_MAX;
        }

        _tileIndex = tileIndex;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [self initWithTileIndex:[[dictionary objectForKey:@"tileIndex"] intValue]]) {
        int i = 0;
        for (NSString *direction in [NSArray arrayWithObjects:@"nw", @"n", @"ne", @"w", @"e", @"sw", @"s", @"se", nil]) {
            NSString *ruleForDirection = dictionary[@"map"][direction];
            if (ruleForDirection) {
                if ([ruleForDirection hasPrefix:@"!"]) {
                    notEquals[i] = [LandscapeMapTileName mapTileForName:[ruleForDirection substringFromIndex:1]];
                    NSLog(@"%@", [ruleForDirection substringFromIndex:1]);
                } else {
                    equals[i] = [LandscapeMapTileName mapTileForName:ruleForDirection];
                }
            } else {
                equals[i] = LandscapeMapTile_MAX;
                notEquals[i] = LandscapeMapTile_MAX;
            }
            i++;
        };
    }
    return self;
}

- (BOOL)isAppliesToNeighbours:(LandscapeMapTile[8])neighbours
{
    for (int i = 0; i < 8; i++) {
        if (equals[i] != LandscapeMapTile_MAX) {
            if (equals[i] != neighbours[i]) {
                return NO;
            }
        }

        if (notEquals[i] != LandscapeMapTile_MAX) {
            if (notEquals[i] == neighbours[i]) {
                return NO;
            }
        }
    }
    return YES;
}


@end

@implementation LandscapeAssetChooser
+ (LandscapeAssetChooser *)sharedChooser
{
    static LandscapeAssetChooser *sharedChooser;

    @synchronized (self) {
        if (!sharedChooser)
            sharedChooser = [[LandscapeAssetChooser alloc] init];

        return sharedChooser;
    }
}


- (id)init
{
    if (self = [super init]) {
        NSMutableDictionary *scheme = [NSMutableDictionary dictionary];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"dungeon_tileset_scheme" withExtension:@"plist"]];
        tileFrameNameFormat = [plist objectForKey:@"tileFrameNameFormat"];
        NSDictionary *types = [plist objectForKey:@"type"];
        for (NSString *typeName in types) {
            NSDictionary *type = [types objectForKey:typeName];
            LandscapeAssetChooserRule *defaultRule = [[LandscapeAssetChooserRule alloc] initWithTileIndex:[[type objectForKey:@"defaultTileIndex"] intValue]];
            NSMutableArray *rules = [NSMutableArray array];
            for (NSDictionary *rule in [type objectForKey:@"rules"]) {
                LandscapeAssetChooserRule *chooserRule = [[LandscapeAssetChooserRule alloc] initWithDictionary:rule];
                [rules addObject:chooserRule];
            }
            [rules addObject:defaultRule];
            [scheme setObject:[NSArray arrayWithArray:rules] forKey:typeName];
        };
        landscapeTilesetScheme = [NSDictionary dictionaryWithDictionary:scheme];
    }
    return self;
}


- (NSString *)frameNameForMapTile:(LandscapeMapTile)mapTile withNeighbours:(LandscapeMapTile[8])neighbours
{
    NSString *baseTileName = [LandscapeMapTileName nameForMapTile:mapTile];
    NSArray *rules = [landscapeTilesetScheme objectForKey:baseTileName];
    for (LandscapeAssetChooserRule *rule in rules) {
        if ([rule isAppliesToNeighbours:neighbours]) {
            return [NSString stringWithFormat:tileFrameNameFormat, rule.tileIndex];
        }
    }
    return nil;
}
@end
