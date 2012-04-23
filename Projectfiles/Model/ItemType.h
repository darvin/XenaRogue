//
//  ItemType.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/8/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObjectType.h"
@interface ItemType : GameObjectType
+(ItemType*) itemTypeWithName:(NSString*) name;
@end
