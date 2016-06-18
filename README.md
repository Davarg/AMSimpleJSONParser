# AMSimpleJSONParser

[![CI Status](http://img.shields.io/travis/Alex Makushkin/AMSimpleJSONParser.svg?style=flat)](https://travis-ci.org/Alex Makushkin/AMSimpleJSONParser)
[![Version](https://img.shields.io/cocoapods/v/AMSimpleJSONParser.svg?style=flat)](http://cocoapods.org/pods/AMSimpleJSONParser)
[![License](https://img.shields.io/cocoapods/l/AMSimpleJSONParser.svg?style=flat)](http://cocoapods.org/pods/AMSimpleJSONParser)
[![Platform](https://img.shields.io/cocoapods/p/AMSimpleJSONParser.svg?style=flat)](http://cocoapods.org/pods/AMSimpleJSONParser)

## Installation

AMSimpleJSONParser is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AMSimpleJSONParser"
```

#### or

You can always clone repository and just add files to your project

```
git clone https://github.com/Davarg/AMSimpleJSONParser.git
```

## Description

If you are looking for simple and lightweight approach for parsing JSON data - you found it. All you need to know class of model and JSON data.

## Example

```objc
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

@interface AMTestModel : NSObject
    @property (strong, setter=customSetterGreeting:) NSDictionary* greeting;
    @property (strong) NestingLevelOne* nestingLevelOne;
    @property (strong) NSArray* friends;
    @property (strong) NSString* uniqId;
@end
..........................................................................
AMTestModel *testModel = [AMSimpleJsonParser parseJsonWithData:[testString dataUsingEncoding:NSUTF8StringEncoding] andWithModelClass:[AMTestModel class] andWithErrorObject:&error];
..........................................................................
````

## Author

Alex Makushkin, maka-dava@yandex.ru

## License

AMSimpleJSONParser is available under the MIT license. See the LICENSE file for more info.
