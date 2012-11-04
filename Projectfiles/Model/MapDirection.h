//
//  MapDirection.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/9/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MapDirectionNW,
    MapDirectionN,
    MapDirectionNE,
    MapDirectionW,
    MapDirectionE,
    MapDirectionSW,
    MapDirectionS,
    MapDirectionSE,
    MapDirection_MAX
} MapDirection;

MapDirection MapDirectionFromDegrees(float degrees);

MapDirection MapDirectionRandom();

MapDirection MapDirectionRandomStreight();

#define kMapDirectionNames @"nw", @"n", @"ne", @"w", @"e", @"sw", @"s", @"se", nil

@interface MapDirectionName : NSObject
+ (NSString *)nameMapDirection:(MapDirection)mapDirection;
@end


@interface NSValue (MapDirection)
+ (NSValue *)valueWithMapDirection:(MapDirection)mapDirection;

- (MapDirection)mapDirectionValue;
@end
