//
//  Coords.h
//  XenaRogue
//
//  Created by Sergey Klimov on 11/4/12.
//
//

#import <Foundation/Foundation.h>

@interface Coords : NSObject <NSCopying>
- (id) initWithX:(int)x Y:(int) y;
+ (Coords*) coordsWithX:(int)x Y:(int)y;
@property (readonly) int x;
@property (readonly) int y;
@end
