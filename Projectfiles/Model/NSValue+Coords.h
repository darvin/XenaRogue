//
//  NSValue+Coords.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapDirection.h"
typedef struct {
    int x;
    int y;
} Coords;
static const Coords CoordsNull = {
    .x = INT_MAX,
    .y = INT_MAX,
};



Coords CoordsMake(int x, int y);
BOOL CoordsIsNull(Coords coords);
Coords CoordsSum(Coords c1, Coords c2);
Coords CoordsDeltaForDirection(MapDirection direction);
@interface NSValue (Coords)
+(NSValue*) valueWithCoords:(Coords)coords;
@end
