//
//  NSValue+MapObjectId.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int GameObjectId;

@interface NSValue (GameObjectId)
+ (NSValue *)valueWithGameObjectId:(GameObjectId)gameObjectId;

- (GameObjectId)gameObjectIdValue;
@end
