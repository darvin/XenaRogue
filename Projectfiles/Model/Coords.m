//
//  Coords.m
//  XenaRogue
//
//  Created by Sergey Klimov on 11/4/12.
//
//

#import "Coords.h"

@implementation Coords
@synthesize x=_x, y=_y;

- (id) initWithX:(int)x Y:(int) y {
    if (self=[super init]) {
        _x = x,
        _y = y;
    }
    return self;
}

- (Coords*) coordsWithX:(int)x Y:(int)y{
    return [[Coords alloc] initWithX:x Y:y];
}


- (id)copyWithZone:(NSZone *)zone {
    //not supports subclassing, but subclassing does not make sense anyway
    id copy = [[Coords alloc] initWithX:_x Y:_y];
    return copy;
}

-(NSUInteger) hash {
    return _x + 31*_y;
}

-(BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[self class]])
        return NO;
    else {
        Coords *other = object;
        return other.x==self.x && other.y==self.y;
    }
}


-(Coords*) coordsByAddingCoords:(Coords*) other {
    return [Coords coords]
}
@end
