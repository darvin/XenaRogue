//
//  NSValue+Coords.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "NSValue+Coords.h"
#import "MapDirection.h"
Coords CoordsMake(int x, int y) {
    Coords result = {
        .x = x,
        .y = y
    };
    return result;
}

Coords CoordsSum(Coords c1, Coords c2) {
    return CoordsMake(c1.x+c2.x, c1.y+c2.y);
}

BOOL CoordsIsNull(Coords coords) {
    return coords.x==CoordsNull.x&&coords.y==CoordsNull.y;
}

Coords CoordsDeltaForDirection(MapDirection direction) {
    int x,y;
    switch (direction) {
        
        case MapDirectionNW:
            x=-1, y=-1;
            break;
        case MapDirectionN:
            x=0, y=-1;
            break;
        case MapDirectionNE:
            x=1, y=-1;
            break;
        case MapDirectionSW:
            x=-1, y=1;
            break;
        case MapDirectionS:
            x=0, y=1;
            break;
        case MapDirectionSE:
            x=1, y=1;
            break;
        case MapDirectionW:
            x=-1, y=0;
            break;
        case MapDirectionE:
            x=1, y=0;
            break;            
        default:
            x=0, y=0;
            break;
    }
    return CoordsMake(x, y);
}

@implementation NSValue (Coords)

+(NSValue*) valueWithCoords:(Coords)coords
{
    return [NSValue value: &coords withObjCType: @encode(Coords)];
}
@end
