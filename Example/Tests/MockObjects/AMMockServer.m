//
//  AMMockServer.m
//  AMSimpleJSONParser
//
//  Created by Александр Макушкин on 19.06.16.
//  Copyright © 2016 Alex Makushkin. All rights reserved.
//

#import "AMMockServer.h"

@implementation AMMockServer

+ (NSData*)getSuccessfulResponse {
    /*
     [
       {
         "uniqId":"575e4f0720a07e414e6c1cdc",
         "tags":
         [
           "enim",
           "anim",
           "fugiat",
           "culpa",
           "qui",
           "tempor",
           "magna"
         ],
         "friends":
         [
           {
             "id\:0,
             "name":"Hines Munoz"
           },
           {
             "id":1,
             "name":"Nancy Gibson"
           },
           {
             "id":2,
             "name":"Bender Burt"
           }
         ],
         "greeting":
         {
           "id":0,
           "name":"Georgette Decker"
         },
         "nestingLevelOne":
         {
           "nestingLevelTwo":
           {
             "nestingLevelThree":
             {
               "nestingLevelFour":
               {
                 "lastProperty":"LastProperty"
               }
             }
           }
         }
       }
     ]
     */
    static NSString *testString = @"[{\"uniqId\":\"575e4f0720a07e414e6c1cdc\",\"tags\":[\"enim\",\"anim\",\"fugiat\",\"culpa\",\"qui\",\"tempor\",\"magna\"],\"friends\":[{\"id\":0,\"name\":\"Hines Munoz\"},{\"id\":1,\"name\":\"Nancy Gibson\"},{\"id\":2,\"name\":\"Bender Burt\"}],\"greeting\":{\"id\":0,\"name\":\"Georgette Decker\"},\"nestingLevelOne\":{\"nestingLevelTwo\":{\"nestingLevelThree\":{\"nestingLevelFour\":{\"lastProperty\":\"LastProperty\"}}}}}]";
    
    return [testString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData*)getNotSuccessfulResponse {
    /*
     [
       {
         "uniqId":"575e4f0720a07e414e6c1cdc",
         "tags":
         [
           "enim",
           "anim",
           "fugiat",
           "culpa",
           "qui",
           "tempor",
           "magna"
     
         ***BROKEN***
       }
     ]
     */
    static NSString *testString = @"[{\"uniqId\":\"575e4f0720a07e414e6c1cdc\",\"tags\":[\"enim\",\"anim\",\"fugiat\",\"culpa\",\"qui\",\"tempor\",\"magna\"}]";
    
    return [testString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
