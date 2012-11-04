//
//  DirectiveMove.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/13/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "DirectiveMove.h"
#import "NSValue+Coords.h"
#import "GameObjectId.h"
#import "GameModel.h"

@implementation DirectiveMove

- (void)runOnGameModel:(GameModel *)gameModel
{
    [super runOnGameModel:gameModel];
    GameObjectId* objectId = args[0];
    Coords moveTo = [(NSValue *) args[1] coordsValue];
    GameObject *object = [gameModel.currentMap objectById:objectId];
    [object moveToCoords:moveTo];
}
@end
