//
//  Creature.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameObject.h"
#import "MapDirection.h"

@class CreatureType;
@class Item;

@interface Creature : GameObject {
    Coords rallyPoint;
};
@property(weak) CreatureType *type;
@property(strong) NSArray *wieldedItems;
@property(nonatomic) int hp;
@property(nonatomic) uint fovDistance;
@property MapDirection direction;

- (void)directiveMove:(Coords)coords;

- (void)pickupItem:(Item *)item;
@end
