//
//  Item.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameObject.h"
@class ItemType;
@interface Item : GameObject
@property (weak) ItemType* type;
@end
