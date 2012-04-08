//
//  ObjectWithCoords.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSValue+Coords.h"
@class GameObject;
@class Map;
@protocol ObjectWithCoords <NSObject>
@property (readwrite) Coords coords;
@property (weak) Map* map;
@end
