//
//  Stairs.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/22/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Stairs.h"

@implementation Stairs
@synthesize down;
-(NSString*) assetName {
    return self.down?@"stone_stairs_down":@"stone_stairs_up";
}
- (GameMapLayer) mapLayer {
    return GameMapLayerOnFloor;
}

@end
