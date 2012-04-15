//
//  MapObjectSprite.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "MapObjectSprite.h"
#import "MapLayer.h"
@implementation MapObjectSprite
-(id) initWithSpriteFrameName:(NSString *)spriteFrameName {
    if (self=[super initWithSpriteFrameName:spriteFrameName]) {
    } 
    return self;
}

-(void) setPosition:(CGPoint)position {
    CGPoint realPosition = CGPointMake(position.x, position.y-spriteSize+self.contentSize.height);
    
    [super setPosition:realPosition];
}
@end
