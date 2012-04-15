//
//  Map.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Map.h"
#import "LocalPlayer.h"
#import "NSValue+Coords.h"
#import "MapDirection.h"

#define RANDOM(from, to) ((arc4random() % (to)-(from))+(from))


MapSize MapSizeMake(int x, int y) {
    MapSize result = {
        .x = x,
        .y = y
    };
    return result;
}

MapRect MapRectMake(int x, int y, int width, int height) {
    MapRect result = {
        .origin.x = x,
        .origin.y = y,
        .size.x = width,
        .size.y = height
    };
    return result;
}



@implementation Map
@synthesize size=_size;
- (id) initWithSize:(MapSize) size {
    if (size.x>kMapMAX_X||size.y>kMapMAX_Y) {
        @throw [NSException exceptionWithName:@"MapError" reason:@"Map too big" userInfo:nil];
    }
    if (self=[super init]) {
        objectsById = [[NSMutableDictionary alloc] init];
        objectsByCoords = [[NSMutableDictionary alloc] init];
        _size = size;
    }
    return self;
}

- (Coords) randomCoords {
//    return NULL;
}

- (MapRect) rect {
    return MapRectMake(0, 0, self.size.x, self.size.y);
}

- (void) generateMap {
//    generateMap(30, 30, 39);
}

- (id) initAndGenerateWithLocalPlayer:(LocalPlayer*) localPlayer andSize:(MapSize) size {
    if (self=[self initWithSize:size]) {
        [self generateMap];
        [self _passableCacheUpdate];
    }
    return self;
}


- (id) initAndWithLocalPlayer:(LocalPlayer*) localPlayer andURL:(NSURL*)fileURL {
    // read everything from text
    NSString* fileContents = 
    [NSString stringWithContentsOfURL:fileURL  
                              encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = 
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    // then break down even further 
    NSString* firstLine = [allLinedStrings objectAtIndex:0];
    
    
    Coords size = CoordsMake([firstLine length], [allLinedStrings count]);
    
    if (self=[self initWithSize:size]) {
        for (uint j=0; j<[allLinedStrings count]; j++) {
            NSString *line = [allLinedStrings objectAtIndex:j];
            for (uint i=0; i<[line length]; i++) {
                unichar currentChar = [line characterAtIndex:i];
                LandscapeMapTile tile = [LandscapeMapTileName mapTileForASCIIChar:[NSString stringWithCharacters:&currentChar length:1]];
                landscape[i][j] = tile;
            }
        }
        [self _passableCacheUpdate];
    }
    return self;
}

- (void) _passableCacheUpdate {
    for(int x=0;x<self.size.x;x++)
	{
		for(int y=0;y<self.size.y;y++)
		{
            mapNodes[x][y].walkable = [self isPassableAtCoords:CoordsMake(x, y)];
        }
    }
}

- (void) _passableCacheUpdateOnCoords:(Coords) coords {
    mapNodes[coords.x][coords.y].walkable = [self isPassableAtCoords:coords];
}

- (void) _mapNodesInit
{    
	for(int x=0;x<self.size.x;x++)
	{
		for(int y=0;y<self.size.y;y++)
		{
            
			mapNodes[x][y].onopen = FALSE;
			mapNodes[x][y].onclosed = FALSE;
			mapNodes[x][y].g = 0;
			mapNodes[x][y].h = 0;
			mapNodes[x][y].f = 0;
			mapNodes[x][y].parent = CoordsNull;
		}
	}
}


- (NSMutableArray *) mutableObjectsAtCoords:(Coords) coords {
    return [objectsByCoords objectForKey:[NSValue valueWithCoords:coords]];
}


- (LandscapeMapTile) landscapeMapTileAtCoords:(Coords)coords {
    if (coords.x<0||coords.y<0||coords.x>self.size.x||coords.y>self.size.y) {
        return LandscapeMapTileEmpty;
    }
    
    //Fixme ceiling hack
    if (coords.y<self.size.y) {
        if (landscape[coords.x][coords.y+1]==LandscapeMapTileWall&&landscape[coords.x][coords.y]==LandscapeMapTileWall) {
            return LandscapeMapTileCeiling;
        }
    }
    
    return landscape[coords.x][coords.y];
}

- (LandscapeMapTile) landscapeMapTileOnDirection:(MapDirection)direction fromCoords:(Coords)coords {
    Coords delta = CoordsDeltaForDirection(direction);
    Coords result = CoordsSum(coords, delta);
    return [self landscapeMapTileAtCoords:result];
}



- (void) _putObject:(GameObject*)object toCoords:(Coords) coords{
    NSMutableArray * objects = [self mutableObjectsAtCoords:coords];
    if (!objects) {
        objects = [NSMutableArray arrayWithObject:object];
        [objectsByCoords setObject:objects forKey:[NSValue valueWithCoords:coords]];
    } else {
        [objects addObject:object];
    }
    [objectsById setObject:object forKey:[NSValue valueWithGameObjectId:object.objectId]];
    [self _passableCacheUpdateOnCoords:coords];
}



- (BOOL) moveObject:(GameObject*)object toCoords:(Coords) coords {
    [[self mutableObjectsAtCoords:object.coords] removeObject:object];
    [self _passableCacheUpdateOnCoords:object.coords];

    [object setCoords:coords];
    [self _putObject:object toCoords:coords];
    return YES;
}

- (void) putObject:(GameObject*)object toCoords:(Coords) coords{
    if (object.map==self) {
        @throw [NSException exceptionWithName:@"MapError" reason:@"Trying to reput object to same map" userInfo:nil];
    }
    [object setCoords:coords andMap:self];
    [self _putObject:object toCoords:coords];
}

- (void) removeObject:(GameObject*) object {
    [objectsById removeObjectForKey:[NSValue valueWithGameObjectId:object.objectId]];
    [[self mutableObjectsAtCoords:object.coords] removeObject:object];
    [object removeCoordsAndMap];
}

- (GameObject *) objectById:(GameObjectId) mapObjectId {
    return [objectsById objectForKey:[NSValue valueWithGameObjectId:mapObjectId]];
}

- (NSArray *) objectsAtCoords:(Coords) coords {
    return [NSArray arrayWithArray:[self mutableObjectsAtCoords:coords]]; //sort by layer
}

- (BOOL) isPassableAtCoords:(Coords) coords {
    if (!LandscapeMapTileIsPassable([self landscapeMapTileAtCoords:coords])) {
        return NO;
    }
    for (GameObject *object in [self objectsAtCoords:coords]) {
        if (![object isPassable])
            return NO;
    }
    return YES;
}

- (BOOL) isVisibleAtCoords:(Coords) coords {
    return YES;
}

- (BOOL) isShootableAtCoords:(Coords) coords {
    return YES;
}



- (NSArray*) findPathFromCoords:(Coords) start toCoords:(Coords) end
{
//    Coords end = CoordsMake(5, 6);
    
    [self _mapNodesInit];
    int currentCost;
	Coords current = start;
	
    for(int x=0;x<self.size.x; x++)
    {
        for(int y=0;y<self.size.y; y++)
        {
            Coords d = CoordsMake(x,y);
            mapNodes[d.x][d.y].h = (abs(end.x-d.x) +abs(end.y-d.y) )* 10;
        }
    }
    
    
	// add starting node to open list
	mapNodes[start.x][start.y].onopen = TRUE;

    while (!(current.x==end.x&&current.y==end.y)) {
        int lowestF = 0;
        for(int x=0;x<self.size.x; x++)
		{
			for(int y=0;y<self.size.y; y++)
			{
                Coords d = CoordsMake(x,y);
				mapNodes[d.x][d.y].f = mapNodes[d.x][d.y].g + mapNodes[d.x][d.y].h;
				if(mapNodes[d.x][d.y].walkable&&mapNodes[d.x][d.y].onopen&&(lowestF==0||mapNodes[d.x][d.y].f<lowestF)) 
                { 
                    current = d; 
                    lowestF = mapNodes[d.x][d.y].f;
                        
                }
			}
		}
        
        mapNodes[current.x][current.y].onopen = FALSE;
        mapNodes[current.x][current.y].onclosed = TRUE;
        
        for(int dx=-1;dx<=1;dx++)
		{
			for(int dy=-1;dy<=1;dy++)
			{
                Coords d = CoordsMake(current.x+dx,current.y+dy);
                if(dx!=0 && dy!=0) currentCost = 14; // diagonals cost 14
                else currentCost = 10; // straights cost 10
                currentCost += mapNodes[current.x][current.y].g;
                if ((dx==0&&dy==0)||!mapNodes[d.x][d.y].walkable) {
                    continue;
                }
                if (mapNodes[d.x][d.y].onclosed&&(mapNodes[d.x][d.y].g>currentCost)) {
                    mapNodes[d.x][d.y].g=currentCost;
                    mapNodes[d.x][d.y].parent = current;
                } else if (mapNodes[d.x][d.y].onopen&&(mapNodes[d.x][d.y].g>currentCost)) {
                    mapNodes[d.x][d.y].g=currentCost;
                    mapNodes[d.x][d.y].parent = current;
                } else if (!mapNodes[d.x][d.y].onopen&&(!mapNodes[d.x][d.y].onclosed)){
                    mapNodes[d.x][d.y].onopen = YES;
                    mapNodes[d.x][d.y].g=currentCost;
                    mapNodes[d.x][d.y].parent = current;
                } 
                
            }
        }
        
        
    }
    
	current = end;
    NSMutableArray * result = [NSMutableArray array];
    while(!(current.x==start.x&&current.y==start.y))
    {
        [result addObject:[NSValue valueWithCoords:current]];
        current = mapNodes[current.x][current.y].parent;
    }
    return [NSArray arrayWithArray:result];
}


-(void) tick {
    [objectsById enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id<Tickable> object = obj;
        [object tick];
    }];
}


- (NSDictionary*) toDictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setValue:[NSValue valueWithCoords:self.size] forKey:@"size"];
    
    LandscapeMapTile _landscape[self.size.x][self.size.y];
    for (int x=0; x<self.size.x; x++) {
        for (int y=0; y<self.size.y; y++) {
            _landscape[x][y] = landscape[x][y];
        }
    }
    [result setValue:[NSData dataWithBytes:_landscape length:sizeof(LandscapeMapTile)*self.size.x*self.size.y] forKey:@"landscape"];
    
    NSMutableArray * objects = [NSMutableArray arrayWithCapacity:[objectsById count]];
    [objectsById enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        GameObject * object= obj;
        [objects addObject:[object toDictionary]];
    }];
    [result setValue:[NSArray arrayWithArray: objects] forKey:@"objects"];
    
    
    NSLog(@"%@", result);
    
    return [NSDictionary dictionaryWithDictionary:result];

}
- (id) initWithDictionary:(NSDictionary*) dictionary {
    
}

@end
