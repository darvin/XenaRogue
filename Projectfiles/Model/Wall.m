//
//  Wall.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Wall.h"

@implementation Wall
- (GameMapLayer) mapLayer {
    return GameMapLayerFloor;
}
-(NSString*) frameName {
    return @"grey_wall";
}
@end
