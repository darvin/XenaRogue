//
//  MapDirection.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/9/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "MapDirection.h"
#import "Map.h"

MapDirection MapDirectionFromDegrees(float degrees) {
    switch ((int) degrees) {
        case 0:
            return MapDirectionE;
            break;
        case 45:
            return MapDirectionNE;
            break;
        case 90:
            return MapDirectionN;
            break;
        case 135:
            return MapDirectionNW;
            break;
        case 180:
            return MapDirectionW;
            break;
        case 225:
            return MapDirectionSW;
            break;
        case 270:
            return MapDirectionS;
            break;
        case 315:
            return MapDirectionSE;
            break;
        case 360:
            return MapDirectionE;
            break;
        default:
            return MapDirection_MAX;
            break;
    }
}


MapDirection MapDirectionRandom() {
    return RANDOM(0, MapDirection_MAX - 1);
}

MapDirection MapDirectionRandomStreight() {
    int i = RANDOM(0, 4);
    switch (i) {
        case 0:
            return MapDirectionN;
        case 1:
            return MapDirectionE;
        case 2:
            return MapDirectionW;
        case 3:
            return MapDirectionS;
        default:
            break;
    }
}

@implementation MapDirectionName
+ (NSString *)nameMapDirection:(MapDirection)mapDirection
{
    return [[NSArray arrayWithObjects:kMapDirectionNames] objectAtIndex:mapDirection];
}
@end


@implementation NSValue (MapDirection)

+ (NSValue *)valueWithMapDirection:(MapDirection)mapDirection
{
    return [NSValue value:&mapDirection withObjCType:@encode(MapDirection)];
}

- (MapDirection)mapDirectionValue
{
    MapDirection result;
    [self getValue:&result];
    return result;
}

@end


