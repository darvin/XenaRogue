//
//  Item.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Item.h"
#import "ItemType.h"
#import "Creature.h"
#import "GameModel.h"

@implementation Item
@synthesize type = _type;

- (GameMapLayer)mapLayer
{
    return GameMapLayerOnFloor;
}

- (id)initWithType:(ItemType *)itemType
{
    if (self = [super init]) {
        _type = itemType;
    }
    return self;
}

+ (Item *)itemWithTypeName:(NSString *)name
{
    return [[Item alloc] initWithType:[ItemType itemTypeWithName:name]];
}

- (NSString *)assetName
{
    //fixme save links to itemtypes
    return @"corpse";
//    return self.type.assetName;
}

- (BOOL)isPassable
{
    return YES;
}

- (BOOL)isRemovable
{
    return YES;
}

- (void)interactedWithObject:(GameObject *)object
{
    if ([object isKindOfClass:[Creature class]]) {
        [self removeFromMap];
        [((Creature *) object) pickupItem:self];
        [GameModel log:[NSString stringWithFormat:@"%@ picked up %@", object, self]];
    }
}


- (NSString *)description
{
    return @"Corpse"; //fixme save links to itemtypes [self.type description];
}
@end
