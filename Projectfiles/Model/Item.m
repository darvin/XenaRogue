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
@implementation Item
@synthesize  type=_type;
- (GameMapLayer) mapLayer {
    return GameMapLayerOnFloor;
}

-(id) initWithType:(ItemType*) itemType{
    if (self=[super init]) {
        _type = itemType;
    }
    return self;
}
+(Item*) itemWithTypeName:(NSString*) name {
    return [[Item alloc] initWithType: [ItemType itemTypeWithName:name]];
}

-(NSString*) assetName  {
    return self.type.assetName;
}
-(BOOL) isPassable{ 
    return YES;
}

-(BOOL) isRemovable {
    return YES;
}

-(void) interactWithObject:(GameObject *)object {
    if ([object isKindOfClass:[Creature class]]) {
        [self removeFromMap];
        [((Creature*)object) pickupItem:self];
    }
}
@end
