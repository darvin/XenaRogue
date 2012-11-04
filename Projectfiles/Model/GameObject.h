//
//  GameObject.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjectWithCoords.h"
#import "ConvertableToDictionary.h"
#import "NSValue+GameObjectId.h"
#import "Map.h"
#import "Tickable.h"

@protocol ObjectWithCoords;
@protocol ConvertableToDictionary;


@interface GameObject : NSObject <ObjectWithCoords, ConvertableToDictionary, Tickable>
@property(readonly) GameObjectId objectId;
@property(readonly) GameMapLayer mapLayer;
@property(readonly) NSString *assetName;
@property(readonly) BOOL isRemovable;
@property(readonly) BOOL isPassable;

- (BOOL)moveToCoords:(Coords)coord;

- (void)interactedWithObject:(GameObject *)object;

- (void)notifyObjectChanged;
@end
