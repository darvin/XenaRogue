//
//  ItemType.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/8/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "ItemType.h"

@implementation ItemType
+(ItemType*) itemTypeWithName:(NSString*) name {
    return [[ItemType alloc] init];
}

//fixme
-(NSString*) assetName {
    return @"corpse";
}
@end
