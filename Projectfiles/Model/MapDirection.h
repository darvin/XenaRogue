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

@interface MapDirectionName : NSObject

@end
