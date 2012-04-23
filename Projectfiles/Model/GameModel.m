//
//  GameModel.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/12/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "GameModel.h"
#import "LocalPlayer.h"
#import "GameModelNotifications.h"
@implementation GameModel
@synthesize currentMap=_currentMap, localPlayer=_localPlayer;
-(id) initWithNewLocalPlayer {
    if (self=[super init]){
        self.localPlayer = [[LocalPlayer alloc] initWithXp:0];
        self.currentMap = [[Map alloc] initAndGenerateWithLocalPlayer:self.localPlayer andSize:MapSizeMake(mapSizeX, mapSizeY)];
        self.currentMap.gameModel = self;
        [self notifyGameMapChange];

//        self.currentMap = [[Map alloc] initAndWithLocalPlayer:self.localPlayer andURL:[[NSBundle mainBundle] URLForResource:@"map" withExtension:@"txt"]];
    }
    return self;
}
-(void) playerChangedMap:(Player*) player {
    //fixme for multiplayer
    [player removeFromMap];
    self.currentMap = nil;
    self.currentMap = [[Map alloc] initAndGenerateWithLocalPlayer:self.localPlayer andSize:MapSizeMake(mapSizeX, mapSizeY)];
    self.currentMap.gameModel = self;
    [self notifyGameMapChange];
}
-(void) notifyGameMapChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:GMNGameMapChanged object:self.currentMap];

}

+ (void) log:(NSString*) message {
    [[NSNotificationCenter defaultCenter] postNotificationName:GMNGameLogMessage object:message];

}
-(void) tick {
    [self.currentMap tick];
}
@end
