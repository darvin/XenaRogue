//
//  ModelTest.m
//  ModelTest
//
//  Created by Sergey Klimov on 11/4/12.
//
//

#import "ModelTest.h"
#import "GameModel.h"
@implementation ModelTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    GameModel* gm = [[GameModel alloc] initWithNewLocalPlayer];
    Map *map = gm.currentMap;
    LocalPlayer *player = gm.localPlayer;
    Coords moveTo = [map randomPassableCoordsInRect:map.rect];
    [player directiveMove:moveTo];
    for (int  i=0;  (i<(map.size.x*map.size.y*6)
                     &&(!CoordsIsEqual(player.coords, moveTo))) ;  i++) {
        [gm tick];
        
    }
    STAssertEquals(player.coords, moveTo, @"Player should be on target coords");
}

@end
