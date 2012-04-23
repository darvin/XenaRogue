//
//  Chest.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/22/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Chest.h"

@implementation Chest
@synthesize open=_open;
-(NSString*) assetName {
    return self.open?@"chest2_open":@"chest2_closed";
}
- (GameMapLayer) mapLayer {
    return GameMapLayerOnFloor;
}
-(void) interactWithObject:(GameObject *)object {
    self.open = !self.open;
}

- (void) setOpen:(BOOL)open {
    if (open!=_open) {
        _open=open;
        [self notifyObjectChanged];
    }
}
-(BOOL) isRemovable {
    return NO;
}
-(BOOL) isPassable {
    return NO;
}


@end
