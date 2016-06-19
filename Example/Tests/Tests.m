//
//  AMSimpleJSONParserTests.m
//  AMSimpleJSONParserTests
//
//  Created by Alex Makushkin on 06/18/2016.
//  Copyright (c) 2016 Alex Makushkin. All rights reserved.
//

// https://github.com/Specta/Specta

SpecBegin(AMSimpleJSONParser)

describe(@"these will pass", ^{
    __block NSData *brokenData = nil;
    __block AMMockBasicModel *brokenMockModel = nil;
    
    __block NSData *correctData = nil;
    __block AMMockBasicModel *correctMockModel = nil;
    
    beforeAll(^{
        brokenData = [AMMockServer getNotSuccessfulResponse];
        brokenMockModel = [AMSimpleJsonParser parseJsonWithData:brokenData
                                              andWithModelClass:[AMMockBasicModel class]
                                             andWithErrorObject:nil];
        
        correctData = [AMMockServer getSuccessfulResponse];
        correctMockModel = [AMSimpleJsonParser parseJsonWithData:correctData
                                               andWithModelClass:[AMMockBasicModel class]
                                              andWithErrorObject:nil];
    });
    
    it(@"model object should be nil", ^{
        XCTAssertNil(brokenMockModel);
    });
    
    it(@"model object should not be nil", ^{
        XCTAssertNotNil(correctMockModel);
    });
    
    it(@"field 'tags' should not be nil", ^{
        XCTAssertNotNil(correctMockModel.tags);
    });
    
    it(@"field 'uniqId' should not be nil", ^{
        XCTAssertNotNil(correctMockModel.uniqId);
    });
    
    it(@"field 'friends' should not be nil", ^{
        XCTAssertNotNil(correctMockModel.friends);
    });
    
    it(@"field 'greeting' should not be nil", ^{
        XCTAssertNotNil(correctMockModel.greeting);
    });
    
    it(@"field 'lastProperty' should not be nil", ^{
        XCTAssertNotNil(correctMockModel.nestingLevelOne.nestingLevelTwo.nestingLevelThree.nestingLevelFour.lastProperty);
    });
});

SpecEnd

