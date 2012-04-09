//
//  NSValue+Coords.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "NSValue+Coords.h"
Coords CoordsMake(int x, int y) {
    Coords result = {
        .x = x,
        .y = y
    };
    return result;
}

BOOL CoordsIsNull(Coords coords) {
    return coords.x==CoordsNull.x&&coords.y==CoordsNull.y;
}

@implementation NSValue (Coords)

+(NSValue*) valueWithCoords:(Coords)coords
{
    return [NSValue value: &coords withObjCType: @encode(Coords)];
}
@end
