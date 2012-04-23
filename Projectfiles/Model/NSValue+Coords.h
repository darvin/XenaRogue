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
BOOL CoordsIsEqual(Coords coords1, Coords coords2);
MapDirection MapDirectionFromDeltaCoords(Coords coords1, Coords coords2);
Coords CoordsDifference(Coords c1, Coords c2);
uint CoordsDistance(Coords c1, Coords c2);

@interface NSValue (Coords)
+(NSValue*) valueWithCoords:(Coords)coords;
-(Coords) coordsValue;
@end
