//
//  Map+Generation.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/16/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Map+Generation.h"

 struct  Room{
    Coords origin;
    MapSize size;
    struct Room* roomA;
    struct Room* roomB;
} ;

#define MIN_ROOM_SIZE_X 9
#define MIN_ROOM_SIZE_Y 9
#define FROM_DIVISION 0.3
#define TO_DIVISION 0.7
#define RANDOMIZE_BORDER_EDGE 8

@implementation Map (Generation)
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

-(void) generateMap {
    struct Room *firstRoom;
    firstRoom = malloc(sizeof(struct Room));
    firstRoom->size = self.size;
    firstRoom->origin = CoordsMake(0, 0);
    [self divideRoom:firstRoom];
    
    [self drawRoom:firstRoom];
}

-(void) randomizeRoom:(struct Room*) roomP {
    int l = arc4random()%RANDOMIZE_BORDER_EDGE;
    int r = arc4random()%RANDOMIZE_BORDER_EDGE;
    int u = arc4random()%RANDOMIZE_BORDER_EDGE;
    int d = arc4random()%RANDOMIZE_BORDER_EDGE;
    if (roomP->size.x-l-r>MIN_ROOM_SIZE_X) {
        roomP->size.x = roomP->size.x-l-r;
        roomP->origin.x = roomP->origin.x+l;
    }
    if (roomP->size.y-u-d>MIN_ROOM_SIZE_Y) {
        roomP->size.y = roomP->size.y-d-u;
        roomP->origin.y = roomP->origin.y+u;
    }

}

-(void) drawRoom:(struct Room*) roomP {
    if (!((roomP->roomA==NULL)||(roomP->roomB==NULL))) {
        [self drawRoom:roomP->roomA];
        [self drawRoom:roomP->roomB];
    } else {
        for (int x=roomP->origin.x; x<=roomP->origin.x+roomP->size.x; x++) {
            
            for (int y=roomP->origin.y; y<=roomP->origin.y+roomP->size.y; y++) {
                landscape[x][y] = LandscapeMapTileFloor;
                
                landscape[roomP->origin.x][y] = LandscapeMapTileWall;
                landscape[roomP->origin.x+roomP->size.x][y] = LandscapeMapTileWall;
            }
            landscape[x][roomP->origin.y] = LandscapeMapTileWall;
            landscape[x][roomP->origin.y+roomP->size.y] = LandscapeMapTileWall;
            
        }
    }

}

-(void) divideRoom:(struct Room*) roomP {
    float random = [self randomFloatBetween:FROM_DIVISION and:TO_DIVISION];
    float rA = random;
    float rB = 1-random;
    float rMin = rA<rB?rA:rB;
    if (((roomP->size.x*rMin)<MIN_ROOM_SIZE_X)||
        ((roomP->size.y*rMin)<MIN_ROOM_SIZE_Y)) {
        roomP->roomA = NULL;
        roomP->roomB = NULL;
        [self randomizeRoom:roomP];
        return;
    }
    
    Coords originA, originB;
    MapSize sizeA, sizeB;
    if (roomP->size.x<roomP->size.y) {
        //vertical division
        originA = roomP->origin;
        originB = CoordsMake(roomP->origin.x, roomP->origin.y+roomP->size.y*rA+1);
        sizeA = MapSizeMake(roomP->size.x, roomP->size.y*rA-1);
        sizeB = MapSizeMake(roomP->size.x, roomP->size.y*rB);

    } else {
        //horizontal division
        originA = roomP->origin;
        originB = CoordsMake(roomP->origin.x+roomP->size.x*rA+1, roomP->origin.y);
        sizeA = MapSizeMake(roomP->size.x*rA-1, roomP->size.y);
        sizeB = MapSizeMake(roomP->size.x*rB, roomP->size.y);
    }
    struct Room *roomA = malloc(sizeof(struct Room)), *roomB = malloc(sizeof(struct Room));
    roomA->origin = originA;
    roomA->size = sizeA;
    
    roomB->origin = originB;
    roomB->size = sizeB;
    
    roomP->roomA = roomA;
    roomP->roomB = roomB;
    [self divideRoom:roomA];
    [self divideRoom:roomB];
    
    
    
}

@end
