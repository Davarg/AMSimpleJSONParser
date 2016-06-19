//
//  AMMockBasicModel.h
//  AMSimpleJSONParser
//
//  Created by Александр Макушкин on 19.06.16.
//  Copyright © 2016 Alex Makushkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NestingLevelFour : NSObject

@property (strong) NSString* lastProperty;

@end

@interface NestingLevelThree : NSObject

@property (strong) NestingLevelFour* nestingLevelFour;

@end

@interface NestingLevelTwo : NSObject

@property (strong) NestingLevelThree* nestingLevelThree;

@end

@interface NestingLevelOne : NSObject

@property (strong) NestingLevelTwo* nestingLevelTwo;

@end

@interface AMMockBasicModel : NSObject

@property (strong, nonatomic, setter=customSetterGreeting:) NSDictionary* greeting;
@property (strong) NestingLevelOne* nestingLevelOne;
@property (strong) NSArray* friends;
@property (strong) NSString* uniqId;
@property (strong) NSArray* tags;

@end
