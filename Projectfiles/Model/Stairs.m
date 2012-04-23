//
//  Stairs.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/22/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Stairs.h"
#import "Player.h"
#import "GameModel.h"
@implementation Stairs
@synthesize down;
-(NSString*) assetName {
    return self.down?@"stone_stairs_down":@"stone_stairs_up";
}
- (GameMapLayer) mapLayer {
    return GameMapLayerOnFloor;
}
-(void) interactedWithObject:(GameObject *)object {
    if (self.down&& [object isKindOfClass:[Player class]]) {
        [self.map.gameModel playerChangedMap:(Player*)object];
    }
}

-(BOOL) isPassable {
    return YES;
}

-(BOOL) isRemovable {
    return NO;
}

@end
