//
//  Creature.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameObject.h"
@class Creature;
@class Item;
@class CreatureType;
@protocol CreatureDelegate <NSObject>

@optional
-(void) creature:(Creature*) creature wieldItem:(Item*) item;
-(void) creature:(Creature*) creature unwieldItem:(Item*) item;
-(void) creature:(Creature*) attackerCreature hitCreature:(Creature*) targetCreature onHitPoints:(NSUInteger) hitPoints;
-(void) creature:(Creature*) healerCreature healedCreature:(Creature*) targetCreature onHitPoints:(NSUInteger) hitPoints;

@end
@interface Creature : GameObject
@property (weak) id<CreatureDelegate> creatureDelegate;
@property (weak) CreatureType* type;
@property (strong) NSArray * wieldedItems;

@end
