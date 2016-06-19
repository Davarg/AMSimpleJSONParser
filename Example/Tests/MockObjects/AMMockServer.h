//
//  AMMockServer.h
//  AMSimpleJSONParser
//
//  Created by Александр Макушкин on 19.06.16.
//  Copyright © 2016 Alex Makushkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMMockServer : NSObject

+ (NSData*)getSuccessfulResponse;
+ (NSData*)getNotSuccessfulResponse;

@end
