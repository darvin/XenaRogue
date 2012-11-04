//
//  Directive.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConvertableToDictionary.h"

@class GameModel;

@protocol ConvertableToDictionary;

@interface Directive : NSObject <ConvertableToDictionary> {
    NSArray *randomStack;
    NSArray *args;
}

- (id)initWithArgs:(NSArray *)args;

- (id)initWithArgs:(NSArray *)args andRandomStack:(NSArray *)randomStack;

- (void)runOnGameModel:(GameModel *)gameModel;


@end
