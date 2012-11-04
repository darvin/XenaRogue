//
//  DirectiveMove.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/13/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "DirectiveMove.h"
#import "NSValue+Coords.h"
#import "NSValue+GameObjectId.h"
#import "GameModel.h"

@implementation DirectiveMove

- (void)runOnGameModel:(GameModel *)gameModel
{
    [super runOnGameModel:gameModel];
    GameObjectId objectId = [[args objectAtIndex:0] gameObjectIdValue];
    Coords moveTo = [(NSValue *) [args objectAtIndex:1] coordsValue];
    GameObject *object = [gameModel.currentMap objectById:objectId];
    [object moveToCoords:moveTo];
}
@end
