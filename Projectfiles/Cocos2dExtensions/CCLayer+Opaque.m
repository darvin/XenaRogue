//
//  CCLayer+Opaque.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/22/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "CCLayer+Opaque.h"

@implementation CCLayer (CCLayer_Opaque)
// Set the opacity of all of our children that support it
-(void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}
- (GLubyte)opacity {
	for (CCNode *node in [self children]) {
		if ([node conformsToProtocol:@protocol(CCRGBAProtocol)]) {
			return [(id<CCRGBAProtocol>)node opacity];
		}
	}
	return 255;
}
@end
