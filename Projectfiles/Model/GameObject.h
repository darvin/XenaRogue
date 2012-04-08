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
@protocol ObjectWithCoords;
@protocol ConvertableToDictionary;

@interface GameObject : NSObject <ObjectWithCoords, ConvertableToDictionary>
@property (readonly) GameObjectId objectId;
@property (readonly) GameMapLayer mapLayer; 
@property (readonly) NSString* frameName;
@end
