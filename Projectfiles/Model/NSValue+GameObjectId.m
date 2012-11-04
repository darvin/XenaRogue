//
//  NSValue+MapObjectId.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "NSValue+GameObjectId.h"

@implementation NSValue (GameObjectId)
+ (NSValue *)valueWithGameObjectId:(GameObjectId)gameObjectId
{
    return [NSValue value:&gameObjectId withObjCType:@encode(GameObjectId)];
}

- (GameObjectId)gameObjectIdValue
{
    GameObjectId result;
    [self getValue:&result];
    return result;
}
@end
