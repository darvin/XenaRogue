//
//  GameModel.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/12/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameModel.h"
#import "LocalPlayer.h"
@implementation GameModel
@synthesize currentMap=_currentMap, localPlayer=_localPlayer;
-(id) initWithNewLocalPlayer {
    if (self=[super init]){
        self.localPlayer = [[LocalPlayer alloc] initWithXp:0];
        self.currentMap = [[Map alloc] initAndWithLocalPlayer:self.localPlayer andURL:[[NSBundle mainBundle] URLForResource:@"map" withExtension:@"txt"]];
        [self.currentMap putObject:self.localPlayer toCoords:CoordsMake(7, 7)];
    }
    return self;
}
@end