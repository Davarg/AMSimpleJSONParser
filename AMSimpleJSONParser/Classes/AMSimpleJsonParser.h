//
//  AMSimpleJsonParser.h
//  AMSimpleJsonParser
//
//  Created by Александр Макушкин on 11.06.16.
//  Copyright © 2016 Александр Макушкин. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AMErrorCodes) {
    AM_ERRORCODE_PROPERTY_NOT_FOUND,
    AM_ERRORCODE_SELECTOR_NOT_FOUND
};

/**
 Simple class to parse JSON
 All you need are JSON and 'Class' of model
 
 @warning Expecting dictionary at root
 */
@interface AMSimpleJsonParser : NSObject

/**
 Parse JSON data
 
 @param jsonData JSON data that needed to be parsed
 
 @param modelClass Class object from which will be created ModelObject
 
 @param error Object for errors if they will appear
 
 @return Completly configured ModelObject from JSON data
 */
+ (id __nullable)parseJsonWithData:(NSData* __nonnull)jsonData
                 andWithModelClass:(Class __nonnull)modelClass
                andWithErrorObject:(NSError* __nullable * __nullable)error;

/**
 Error domain used in generated errors
 
 @return String that contain error domain for this class
 */
+ (NSString* __nonnull)errorDomain;

@end
