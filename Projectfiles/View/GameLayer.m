//
//  GameLayer.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameLayer.h"

#import "GameViewController.h"
@implementation GameLayer




-(id) init {
    if (self=[super init]) {
        GameViewController *vc = [[GameViewController alloc] initWithLocalPlayer:nil];
        [self addChild:vc.mapLayer];
    }
    return self;
}


@end
