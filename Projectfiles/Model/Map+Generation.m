//
//  Map+Generation.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/16/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Map+Generation.h"

struct Room {
    Coords origin;
    MapSize size;
    struct Room *roomA;
    struct Room *roomB;
};

#define MIN_ROOM_SIZE_X 2
#define MIN_ROOM_SIZE_Y 2
#define FROM_DIVISION 0.3
#define TO_DIVISION 0.7
#define RANDOMIZE_BORDER_EDGE 2
#define POSSIBILITY_LAVA 40
#define POSSIBILITY_WATER 70
#define MIN_ROOM_SIZE_FOR_POOL 8


@implementation Map (Generation)
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber
{
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned) RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (Coords)generateMap
{
    struct Room *firstRoom;
    firstRoom = malloc(sizeof(struct Room));
    firstRoom->size = self.size;
    firstRoom->origin = CoordsMake(0, 0);
    [self divideRoom:firstRoom firstRoom:YES];

    [self drawRoom:firstRoom];
    [self passableCacheFillWalkable];
    [self drawWays:firstRoom];
    [self drawWalls];
    [self drawLavaAndWater:firstRoom];
    Coords localPlayerCoords = [self randomCoordsInRoom:*firstRoom filledWith:LandscapeMapTileFloor];


    return localPlayerCoords;
}

- (void)drawWalls
{
    for (int x = 0; x < self.size.x; x++) {
        for (int y = 0; y < self.size.y; y++) {
            //border hack
            if (landscape[x][0] == LandscapeMapTileFloor)
                landscape[x][0] = LandscapeMapTileWall;
            if (landscape[x][self.size.y - 1] == LandscapeMapTileFloor)
                landscape[x][self.size.y - 1] = LandscapeMapTileWall;
            if (landscape[0][y] == LandscapeMapTileFloor)
                landscape[0][y] = LandscapeMapTileWall;
            if (landscape[self.size.x - 1][y] == LandscapeMapTileFloor)
                landscape[self.size.x - 1][y] = LandscapeMapTileWall;


            if (landscape[x][y] != LandscapeMapTileEmpty)
                continue;

            BOOL makeWall = NO;
            for (int dx = -1; dx <= 1; dx++) {
                for (int dy = -1; dy <= 1; dy++) {
                    if (x == 0 && y == 0) {
                        continue;
                    }
                    LandscapeMapTile neigbour = [self landscapeMapTileAtCoords:CoordsMake(x + dx, y + dy)];
                    if (neigbour != LandscapeMapTileWall && neigbour != LandscapeMapTileCeiling && neigbour != LandscapeMapTileEmpty) {
                        makeWall = YES;
                        break;
                    }
                }
                if (makeWall)
                    break;
            }
            if (makeWall) { //hack for ceilings
                landscape[x][y] = LandscapeMapTileWall;
                if (y > 1 && landscape[x][y - 1] != LandscapeMapTileFloor) {
                    landscape[x][y - 1] = LandscapeMapTileWall;
                }
                if (y < self.size.y && landscape[x][y + 1] != LandscapeMapTileFloor) {
                    landscape[x][y + 1] = LandscapeMapTileWall;
                }
            }
        }
    }
}

- (void)drawWays:(struct Room *)roomP
{
    if (!((roomP->roomA == NULL) || (roomP->roomB == NULL))) {
        [self drawWays:roomP->roomA];
        [self drawWays:roomP->roomB];
        Coords from = [self randomCoordsInRoom:*roomP->roomA filledWith:LandscapeMapTileFloor];
        Coords to = [self randomCoordsInRoom:*roomP->roomB filledWith:LandscapeMapTileFloor];
//        landscape[from.x][from.y] = LandscapeMapTileLava;
//        landscape[to.x][to.y] = LandscapeMapTileWater;

        NSArray *way = [self findPathFromCoords:from toCoords:to allowDiagonal:NO];
        for (NSValue *coordsV in way) {
            Coords c = [coordsV coordsValue];
            landscape[c.x][c.y] = LandscapeMapTileFloor;
        }
    }

}

- (void)drawPoolWithLandscapeTile:(LandscapeMapTile)mapTile startingWithCoords:(Coords)coords size:(uint)size
{
    if (size == 0 || [self landscapeMapTileAtCoords:coords] != LandscapeMapTileFloor) {
        return;
    }
    landscape[coords.x][coords.y] = mapTile;
    Coords newCoords = CoordsSum(coords, CoordsDeltaForDirection(MapDirectionRandomStreight()));
    [self drawPoolWithLandscapeTile:mapTile startingWithCoords:newCoords size:size - 1];
    newCoords = CoordsSum(coords, CoordsDeltaForDirection(MapDirectionRandomStreight()));
    [self drawPoolWithLandscapeTile:mapTile startingWithCoords:newCoords size:size - 1];

}

- (void)drawLavaAndWater:(struct Room *)roomP
{
    if (!((roomP->roomA == NULL) || (roomP->roomB == NULL))) {
        [self drawLavaAndWater:roomP->roomA];
        [self drawLavaAndWater:roomP->roomB];
    } else if ((roomP->size.x >= MIN_ROOM_SIZE_FOR_POOL) || (roomP->size.y >= MIN_ROOM_SIZE_FOR_POOL)) {
        Coords startCoords = [self randomCoordsInRoom:*roomP filledWith:LandscapeMapTileFloor];
        if (arc4random() % 100 < POSSIBILITY_LAVA) {
            [self drawPoolWithLandscapeTile:LandscapeMapTileLava startingWithCoords:startCoords size:RANDOM(4, 7)];
        } else if (arc4random() % 100 < POSSIBILITY_WATER) {
            [self drawPoolWithLandscapeTile:LandscapeMapTileWater startingWithCoords:startCoords size:RANDOM(4, 8)];
        }

    }

}


- (void)passableCacheFillWalkable
{
    for (int x = 0; x < self.size.x; x++) {
        for (int y = 0; y < self.size.y; y++) {
            mapNodes[x][y].walkable = YES;
        }
    }
}

- (Coords)randomCoordsInRoom:(struct Room)room filledWith:(LandscapeMapTile)mapTile
{
    for (int i = 0; i < 100; i++) {
        for (int x = RANDOM(room.origin.x, room.origin.x + room.size.x); x < room.origin.x + room.size.x; x++) {
            for (int y = RANDOM(room.origin.y, room.origin.y + room.size.y); y < room.origin.y + room.size.y; y++) {
                if (landscape[x][y] == mapTile) {
                    return CoordsMake(x, y);
                }
            }
        }
    }
    @throw [NSException exceptionWithName:@"MapGenerationError" reason:@"can not find proper random coords" userInfo:nil];
}

- (void)randomizeRoom:(struct Room *)roomP firstRoom:(BOOL)firstRoom
{
    int l = arc4random() % RANDOMIZE_BORDER_EDGE;
    int r = arc4random() % RANDOMIZE_BORDER_EDGE;
    int u = arc4random() % RANDOMIZE_BORDER_EDGE;
    int d = arc4random() % RANDOMIZE_BORDER_EDGE;
    if (firstRoom) {
        l += 1;
        r += 1;
        u += 1;
        d += 1;
    }
    if (roomP->size.x - l - r > MIN_ROOM_SIZE_X) {
        roomP->size.x = roomP->size.x - l - r;
        roomP->origin.x = roomP->origin.x + l;
    }
    if (roomP->size.y - u - d > MIN_ROOM_SIZE_Y) {
        roomP->size.y = roomP->size.y - d - u;
        roomP->origin.y = roomP->origin.y + u;
    }

}

- (void)drawRoom:(struct Room *)roomP
{
    if (!((roomP->roomA == NULL) || (roomP->roomB == NULL))) {
        [self drawRoom:roomP->roomA];
        [self drawRoom:roomP->roomB];
    } else {
        for (int x = roomP->origin.x; x <= roomP->origin.x + roomP->size.x; x++) {

            for (int y = roomP->origin.y; y <= roomP->origin.y + roomP->size.y; y++) {
                landscape[x][y] = LandscapeMapTileFloor;

//                landscape[roomP->origin.x][y] = LandscapeMapTileWall;
//                landscape[roomP->origin.x+roomP->size.x][y] = LandscapeMapTileWall;
            }
//            landscape[x][roomP->origin.y] = LandscapeMapTileWall;
//            landscape[x][roomP->origin.y+roomP->size.y] = LandscapeMapTileWall;

        }
    }

}

- (void)divideRoom:(struct Room *)roomP firstRoom:(BOOL)firstRoom
{
    float random = [self randomFloatBetween:FROM_DIVISION and:TO_DIVISION];
    float rA = random;
    float rB = 1 - random;
    float rMin = rA < rB ? rA : rB;
    if (((roomP->size.x * rMin) < MIN_ROOM_SIZE_X) ||
            ((roomP->size.y * rMin) < MIN_ROOM_SIZE_Y)) {
        roomP->roomA = NULL;
        roomP->roomB = NULL;
        [self randomizeRoom:roomP firstRoom:firstRoom];
        return;
    }
    if (firstRoom) {
        [self randomizeRoom:roomP firstRoom:firstRoom];

    };

    Coords originA, originB;
    MapSize sizeA, sizeB;
    if (roomP->size.x < roomP->size.y) {
        //vertical division
        originA = roomP->origin;
        originB = CoordsMake(roomP->origin.x, roomP->origin.y + roomP->size.y * rA + 1);
        sizeA = MapSizeMake(roomP->size.x, roomP->size.y * rA - 1);
        sizeB = MapSizeMake(roomP->size.x, roomP->size.y * rB);

    } else {
        //horizontal division
        originA = roomP->origin;
        originB = CoordsMake(roomP->origin.x + roomP->size.x * rA + 1, roomP->origin.y);
        sizeA = MapSizeMake(roomP->size.x * rA - 1, roomP->size.y);
        sizeB = MapSizeMake(roomP->size.x * rB, roomP->size.y);
    }
    struct Room *roomA = malloc(sizeof(struct Room)), *roomB = malloc(sizeof(struct Room));
    roomA->origin = originA;
    roomA->size = sizeA;

    roomB->origin = originB;
    roomB->size = sizeB;

    roomP->roomA = roomA;
    roomP->roomB = roomB;
    [self divideRoom:roomA firstRoom:NO];
    [self divideRoom:roomB firstRoom:NO];


}

@end
