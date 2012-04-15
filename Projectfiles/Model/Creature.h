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
@interface Creature : GameObject {
    Coords rallyPoint;
};
@property (weak) CreatureType* type;
@property (strong) NSArray * wieldedItems;
@property MapDirection direction;
@end
