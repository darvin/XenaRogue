//
//  ConvertableToDictionary.h
//  XenaRogue
//
//  Created by Sergey Klimov on 4/7/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConvertableToDictionary <NSObject>
- (NSDictionary*) toDictionary;
- (id) initWithDictionary:(NSDictionary*) dictionary;
@end
