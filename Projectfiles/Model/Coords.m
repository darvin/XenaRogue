//
//  Coords.m
//  XenaRogue
//
//  Created by Sergey Klimov on 11/4/12.
//
//

#import "Coords.h"
#import "MapDirection.h"

@implementation Coords
@synthesize x=_x, y=_y;

- (id) initWithX:(int)x Y:(int) y {
    if (self=[super init]) {
        _x = x,
        _y = y;
    }
    return self;
}

+ (Coords*) coordsWithX:(int)x Y:(int)y{
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
    return [Coords coordsWithX:_x+other.x Y:_y+other.y];

}

-(Coords*) coordsBySubtractingCoords:(Coords*) other {
    return [Coords coordsWithX:_x-other.x Y:_y-other.y];

}

+(Coords*) coordsDeltaForDirection:(MapDirection) direction {
    int x, y;
    switch (direction) {

        case MapDirectionNW:
            x = -1, y = -1;
            break;
        case MapDirectionN:
            x = 0, y = -1;
            break;
        case MapDirectionNE:
            x = 1, y = -1;
            break;
        case MapDirectionSW:
            x = -1, y = 1;
            break;
        case MapDirectionS:
            x = 0, y = 1;
            break;
        case MapDirectionSE:
            x = 1, y = 1;
            break;
        case MapDirectionW:
            x = -1, y = 0;
            break;
        case MapDirectionE:
            x = 1, y = 0;
            break;
        default:
            x = 0, y = 0;
            break;
    }
    return [Coords coordsWithX:x Y:y];
}


- (MapDirection) mapDirectionToCoords:(Coords*) other {
    if (other.x < self.x && other.y < self.y)
        return MapDirectionNW;
    else if (self.x == other.x && other.y < self.y)
        return MapDirectionN;
    else if (other.x > self.x && other.y < self.y)
        return MapDirectionNE;
    else if (other.x < self.x && other.y > self.y)
        return MapDirectionSW;
    else if (self.x == other.x && other.y > self.y)
        return MapDirectionS;
    else if (other.x > self.x && other.y > self.y)
        return MapDirectionSE;
    else if (other.x > self.x && other.y == self.y)
        return MapDirectionE;
    else if (other.x < self.x && other.y == self.y)
        return MapDirectionW;


    return MapDirection_MAX;
}

-(uint) dictanceToCoords:(Coords*) other {
    Coords* d = [self coordsBySubtractingCoords:other];
    uint max = (uint) (abs(d.x) > abs(d.y) ? d.x : d.y);
    return max;
}

@end
