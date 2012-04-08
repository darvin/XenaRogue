//
//  GameObjectType.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/8/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameObjectType : NSObject
-(id) initFromPlist:(NSString*)plistName withId:(NSString*) typeId;
+(id) gameObjectTypeFromPlist:(NSString*)plistName withId:(NSString*) typeId;
@end
