//
//  NSValue+Coords.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@interface NSValue (Coords)
+(NSValue*) valueWithCoords:(Coords)coords;
@end
