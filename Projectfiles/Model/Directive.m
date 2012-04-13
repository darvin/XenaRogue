//
//  Directive.m
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import "Directive.h"
@interface Directive ()
- (int) randomIntFrom:(int)from to:(int)to;

@end
@implementation Directive

- (id) initWithArgs:(NSArray*) _args {
    if (self=[super init]) {
        args = _args;
    }
    return self;
}

- (void) runOnGameModel:(GameModel*) gameModel {
    
}
@end
