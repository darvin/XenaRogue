//
//  LandscapeAssetChooser.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/9/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LandscapeMapTile.h"

@interface LandscapeAssetChooserRule : NSObject  {
    LandscapeMapTile equals[8];
    LandscapeMapTile notEquals[8];
}
@property (readonly) NSUInteger tileIndex;
- (id) initWithTileIndex:(NSUInteger) tileIndex;
- (id) initWithDictionary:(NSDictionary*) dictionary;
- (BOOL) isAppliesToNeighbours:(LandscapeMapTile[8]) neighbours;
@end

@interface LandscapeAssetChooser : NSObject {
    NSDictionary * landscapeTilesetScheme;
    NSString* tileFrameNameFormat;
}
+ (LandscapeAssetChooser*) sharedChooser;
- (NSString*) frameNameForMapTile:(LandscapeMapTile) mapTile withNeighbours:(LandscapeMapTile[8]) neighbours;

        
@end
