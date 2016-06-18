//
//  AMSimpleJsonParser.m
//  AMSimpleJsonParser
//
//  Created by Александр Макушкин on 11.06.16.
//  Copyright © 2016 Александр Макушкин. All rights reserved.
//

#include <objc/runtime.h>
#import "AMSimpleJsonParser.h"

@interface AMSimpleJsonParser ()

+ (void)prepareError:(NSError**)error forErrorCode:(AMErrorCodes)errorCode;

+ (NSDictionary*)getUserInfoForErrorCode:(AMErrorCodes)errorCode;

+ (SEL)getSelectorSetterForProperty:(objc_property_t)objProperty
          andWithExpectedSetterName:(NSString*)expSetterName;

+ (void)executeSelector:(SEL)selectorForExecute
           andForObject:(id)targetObject
           andWithError:(NSError**)error
  andWithPropertyObject:(objc_property_t)propertyObj
andWithSelectorArgument:(id)selectorArg;

+ (Class)getClassForPropertyObj:(objc_property_t)objProperty;

@end

@implementation AMSimpleJsonParser

///----------------------
#pragma mark - Parse JSON
///----------------------
+ (id)parseJsonWithData:(NSData*)jsonData
      andWithModelClass:(Class)modelClass
     andWithErrorObject:(NSError**)error {
    id parsedDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingAllowFragments
                                                     error:error];
    if (*error != nil) {
        ///----------------------
        #pragma mark - Return NIL
        ///----------------------
        return nil;
    }
    ///-------------------------------------------------
    /// Create array of keys to get properties in object
    ///-------------------------------------------------
    NSArray *arrayOfKeysForParsedDic = nil;
    if (parsedDic != nil
        && (id)parsedDic != [NSNull null]) {
        if ([parsedDic isKindOfClass:[NSArray class]] == YES) {
            arrayOfKeysForParsedDic = [[parsedDic objectAtIndex:0] allKeys];
            parsedDic = [parsedDic objectAtIndex:0];
        } else if ([parsedDic isKindOfClass:[NSDictionary class]]) {
            arrayOfKeysForParsedDic = [parsedDic allKeys];
        }
    }
    
    ///--------------------
    /// Create model object
    ///--------------------
    id resultObject = nil;
    if (arrayOfKeysForParsedDic.count > 0) {
        if (modelClass != nil
            && (id)modelClass != [NSNull null]) {
            resultObject = [[modelClass alloc] init];
        }
        
        if (resultObject != nil
            && resultObject != [NSNull null]) {
            ///--------------------------
            /// Set values for properties
            ///--------------------------
            for (NSInteger indexOfKey = 0; indexOfKey < arrayOfKeysForParsedDic.count; indexOfKey++) {
                NSString *keyOfValue = [arrayOfKeysForParsedDic objectAtIndex:indexOfKey];
                objc_property_t propertyForKey = class_getProperty(modelClass, [keyOfValue cStringUsingEncoding:NSUTF8StringEncoding]);
                
                ///-------------------
                /// Is property exist?
                ///-------------------
                if (propertyForKey != NULL) {
                    SEL selectorSetter = [AMSimpleJsonParser getSelectorSetterForProperty:propertyForKey
                                                                andWithExpectedSetterName:keyOfValue];
                    
                    [AMSimpleJsonParser executeSelector:selectorSetter
                                           andForObject:resultObject
                                           andWithError:error
                                  andWithPropertyObject:propertyForKey
                                andWithSelectorArgument:[parsedDic objectForKey:keyOfValue]];
                } else {
                    [AMSimpleJsonParser prepareError:error forErrorCode:AM_ERRORCODE_PROPERTY_NOT_FOUND];
                    ///----------------------
                    #pragma mark - Return NIL
                    ///----------------------
                    return nil;
                }
            }
        }
    }
    
    return resultObject;
}

///-------------------
#pragma mark - Helpers
///-------------------
+ (void)executeSelector:(SEL)selectorForExecute
           andForObject:(id)targetObject
           andWithError:(NSError**)error
  andWithPropertyObject:(objc_property_t)propertyObj
andWithSelectorArgument:(id)selectorArg {
    ///-----------------------------
    /// Is selector exist in object?
    ///-----------------------------
    if ([targetObject respondsToSelector:selectorForExecute] == YES) {
        Class classOfProperty = [AMSimpleJsonParser getClassForPropertyObj:propertyObj];
        
        if ([selectorArg isKindOfClass:classOfProperty] == YES) {
            [targetObject performSelector:selectorForExecute withObject:selectorArg];
        } else {
            Class classOfObject = [selectorArg class];
            if ([classOfObject isSubclassOfClass:[NSDictionary class]] == YES) {
                NSString *lookingPropertyKey = [[selectorArg allKeys] objectAtIndex:0];
                objc_property_t nestedProperty = class_getProperty(classOfProperty, [lookingPropertyKey cStringUsingEncoding:NSUTF8StringEncoding]);
                
                SEL selectorSetter = [AMSimpleJsonParser getSelectorSetterForProperty:nestedProperty
                                                            andWithExpectedSetterName:lookingPropertyKey];
                id nestedObject = [[classOfProperty alloc] init];
                
                [AMSimpleJsonParser executeSelector:selectorSetter
                                       andForObject:nestedObject
                                       andWithError:error
                              andWithPropertyObject:nestedProperty
                 andWithSelectorArgument:[selectorArg objectForKey:lookingPropertyKey]];
                [targetObject performSelector:selectorForExecute withObject:nestedObject];
            }
        }
    } else {
        [AMSimpleJsonParser prepareError:error forErrorCode:AM_ERRORCODE_SELECTOR_NOT_FOUND];
        return;
    }
}

+ (SEL)getSelectorSetterForProperty:(objc_property_t)objProperty
          andWithExpectedSetterName:(NSString*)expSetterName {
    SEL resultSelector = nil;
    
    const char *setterName = property_copyAttributeValue(objProperty, "S");
    ///---------------------------------------
    /// Is user define custom name for setter?
    ///---------------------------------------
    if (setterName != NULL) {
        resultSelector = NSSelectorFromString([NSString stringWithUTF8String:setterName]);
        free(setterName);
    } else {
        NSString *firstCharacter = [expSetterName substringWithRange:NSMakeRange(0, 1)];
        NSString *nameOfSelector = [NSString stringWithFormat:@"set%@%@:", [firstCharacter capitalizedString], [expSetterName substringWithRange:NSMakeRange(1, expSetterName.length - 1)], nil];
        resultSelector = NSSelectorFromString(nameOfSelector);
    }
    
    return resultSelector;
}

+ (Class)getClassForPropertyObj:(objc_property_t)objProperty {
    Class resultClass = nil;
    
    NSRegularExpression *regularExp = [NSRegularExpression regularExpressionWithPattern:@".+?\"(.+?)\""
                                                                                options:0
                                                                                  error:nil];
    NSString *propertyStringAttributes = [NSString stringWithUTF8String:property_getAttributes(objProperty)];
    NSArray *arrayOfAttributes = [propertyStringAttributes componentsSeparatedByString:@","];
    
    NSString *stringForSearch = [arrayOfAttributes objectAtIndex:0];
    NSTextCheckingResult *regexResult = [regularExp firstMatchInString:stringForSearch
                                                               options:0
                                                                 range:NSMakeRange(0, stringForSearch.length)];
    
    NSString *className = [stringForSearch substringWithRange:[regexResult rangeAtIndex:1]];
    resultClass = NSClassFromString(className);
    
    return resultClass;
}

+ (void)prepareError:(NSError**)error forErrorCode:(AMErrorCodes)errorCode {
    NSDictionary *userInfo = [AMSimpleJsonParser getUserInfoForErrorCode:errorCode];
    
    if (*error == nil) {
        *error = [NSError errorWithDomain:[AMSimpleJsonParser errorDomain]
                                     code:errorCode
                                 userInfo:userInfo];
    } else {
        NSLog(@"FailureReason - %@\nRecoverySuggestion - %@", [userInfo objectForKey:NSLocalizedFailureReasonErrorKey], [userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey], nil);
    }
}

+ (NSDictionary*)getUserInfoForErrorCode:(AMErrorCodes)errorCode {
    static NSString *operationUnsuccessfulKey = @"Operation was unsuccessful.";
    static  NSString *contactAdviceKey = @"Please, contact to author of module.";
    
    static  NSString *unknowReasonKey = @"There was some unexpected error.";
    static  NSString *unknownAdviceKey = @"Please, contact to author of module.";
    
    static  NSString *propertyNotFoundReasonKey = @"Property was not found in object.";
    static  NSString *propertyNotFoundAdviceKey = @"All properties of object must be named like in JSON.";
    
    static  NSString *selectorNotFoundReasonKey = @"Selector was not found in object.";
    
    NSDictionary *resultUserInfo = nil;
    switch (errorCode) {
        case AM_ERRORCODE_PROPERTY_NOT_FOUND:
            resultUserInfo = @{NSLocalizedDescriptionKey:operationUnsuccessfulKey,
                               NSLocalizedFailureReasonErrorKey:propertyNotFoundReasonKey,
                               NSLocalizedRecoverySuggestionErrorKey:propertyNotFoundAdviceKey};
            break;
            
        case AM_ERRORCODE_SELECTOR_NOT_FOUND:
            resultUserInfo = @{NSLocalizedDescriptionKey:operationUnsuccessfulKey,
                               NSLocalizedFailureReasonErrorKey:selectorNotFoundReasonKey,
                               NSLocalizedRecoverySuggestionErrorKey:contactAdviceKey};
            break;
            
        default:
            resultUserInfo = @{NSLocalizedDescriptionKey:operationUnsuccessfulKey,
                               NSLocalizedFailureReasonErrorKey:unknowReasonKey,
                               NSLocalizedRecoverySuggestionErrorKey:unknownAdviceKey};
            break;
    }
    
    return resultUserInfo;
}

+ (NSString*)errorDomain {
    return @"AMSimpleJsonParserErrorDomain";
}

@end
